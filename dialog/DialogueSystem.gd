extends Control

var dialog

func _ready():
	var file = File.new()
	file.open("res://dialog.json", file.READ)
	var text = file.get_as_text()
	dialog = JSON.parse(text).result
	file.close()

#
# Dialogue parsing & functional system
#

var cur_story = null
var cur_message = null

func start_story(id, dict, vars, node):
	if(cur_story != null):
		printerr("DialogueSystem - already started a story")
		return 
	
	var story
	for i in dialog.stories:
		if(i["id"] == id):
			story = i
			break
	
	if(story == null):
		printerr("DialogueSystem - could not find story")
		return
		
	cur_story = {"data": story, "dict": dict, "vars": vars, "node": node}
	open_message(story.start)

func end_story():
	cur_story == null

func open_message(id):
	if(cur_story == null): return
	
	var message
	for i in cur_story.data.messages:
		if(i["id"] == id):
			message = i
			break
	
	if(message == null):
		printerr("DialogueSystem - could not find message")
		crash_dialog()
		return
	
	cur_story.node._story_message(message.id)
	cur_message = message
	
	match message.type:
		"CONTINUE":
			show_dialog()
			show_text(parse_text(message.name, cur_story.dict), parse_text(message.text, cur_story.dict), [{"text": "Continue", "node": self}])
		"QUESTION":
			var choices = []
			for choice in message.choices:
				choices.push_back({"text": parse_text(choice.text, cur_story.dict), "node": self})
			
			show_dialog()
			show_text(parse_text(message.name, cur_story.dict), parse_text(message.text, cur_story.dict), choices)
		"LOGIC":
			var constant = message["const"]
			
			if(constant.is_valid_integer()): constant = int(constant)
			elif(constant.is_valid_float()): constant = float(constant)
			
			match message.prop:
				"EQ": # =
					if(cur_story.vars[message.var] == constant):
						open_message(message.t)
					else: open_message(message.f)
				"LT": # <
					if(cur_story.vars[message.var] < constant):
						open_message(message.t)
					else: open_message(message.f)
				"GT": # >
					if(cur_story.vars[message.var] > constant):
						open_message(message.t)
					else: open_message(message.f)
				"HAS": # .has
					if(cur_story.vars[message.var].has(message["const"])):
						open_message(message.t)
					else: open_message(message.f)
		"EXIT":
			show_dialog()
			show_text(parse_text(message.name, cur_story.dict), parse_text(message.text, cur_story.dict), [{"text": "Exit", "node": self}])
	
func _dialog_pressed(n):
	if(cur_story == null): return
	
	match cur_message.type:
		"CONTINUE":
			open_message(cur_message.next)
		"QUESTION":
			var choice = cur_message.choices[n]
			open_message(choice.next)
		"EXIT":
			hide_dialog()
			cur_story.node._story_exit(cur_message.id)
			cur_story = null
			cur_message = null
			
func crash_dialog():
	hide_dialog()
	cur_story = null
	cur_message = null

func parse_text(text, dict):
	var newstr = ""
	var in_word = false
	var word = ""
	
	for n in range(len(text)):
		var c = text[n]
		if(c == "#"):
			if in_word: 
				newstr += dict[word]
				in_word = false
				word = ""
			else: 
				in_word = true
		else:
			if in_word: word += c
			else: newstr += c
	
	return newstr
#
# Dialogue showing system
#

var choice_functions = [null, null, null]
onready var choice_buttons = [$"Dialogue Box/Choice1", $"Dialogue Box/Choice2", $"Dialogue Box/Choice3"]

func show_dialog():
	$"Dialogue Box".visible = true

func hide_dialog():
	$"Dialogue Box".visible = false

func toggle_dialog():
	$"Dialogue Box".visible = !$"Dialogue Box".visible

func show_text(name_text, text, choices):
	$"Dialogue Box/Name".text = name_text
	$"Dialogue Box/Text".text = text
	
	for n in range(3):
		var button = choice_buttons[n]
		var choice = choices[n] if len(choices) > n else null
		
		if choice == null:
			button.visible = false
			choice_functions[n] = null
		else:
			button.visible = true
			button.text = choice.text
			choice_functions[n] = choice

func pressed(n):
	var choice_function = choice_functions[n]
	
	if(choice_function == null):
		return
	
	choice_function.node._dialog_pressed(n)

func _on_Choice1_pressed():
	pressed(0)

func _on_Choice2_pressed():
	pressed(1)

func _on_Choice3_pressed():
	pressed(2)
