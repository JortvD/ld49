extends Node

var first_time = false

onready var player = $"/root/MainScene/Player"

func _ready():
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var general_store = $"/root/MainScene/Buildings/GeneralStore"
	var house_f = $"/root/MainScene/Buildings/HouseF"
	
	
	$"..".npc_name = "GeneralStoreman"
	$"..".child = self
	$"..".schedule = [
		{"at": 6, "mins": 0,  "type": "MOVE", "moves": [house_f.get_exit_position(), general_store.get_entrance_position(), general_store.get_random_spot()]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), general_store.get_entrance_position(),general_store.get_random_spot()]},
		{"at": 21, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), house_f.get_entrance_position(), house_f.get_random_spot()]}
	]

func _story_message(id, story):
	pass

func _story_exit(id, story):
	$"..".end_conversation()
	if(story == "generalstoreman-working"):
		if(id == "b2a2"):
			player.remove_item("money")
			player.pickup($"/root/MainScene/Items".get_type("gun"))
		
		if(id == "b2b2"):
			player.remove_item("money")
			player.pickup($"/root/MainScene/Items".get_type("pen_and_paper"))
			
		if(id == "c2a2"):
			player.remove_item("money")
			player.pickup($"/root/MainScene/Items".get_type("apple"))
			
		if(id == "c2b2"):
			player.remove_item("money")
			player.pickup($"/root/MainScene/Items".get_type("knife"))

func _handle_entering_player(distance):
	$"..".show_text()
	$"..".set_text("Press SPACE to talk")

func _handle_leaving_player(distance):
	$"..".hide_text()

func _handle_custom_task(task):
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("generalstoreman-first-time", {"npc": $"..".names["GeneralStoreman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 7 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 12) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 14 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 21)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("generalstoreman-working", {"npc": $"..".names["GeneralStoreman"]}, {"money": 1 if $"/root/MainScene/Player".has_item("money") else 0, "reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 21 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 7):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("generalstoreman-sleeping", {"npc": $"..".names["GeneralStoreman"]}, {}, self)
			$"..".start_conversation()

