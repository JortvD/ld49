extends Node2D

var safe_file_path = "user://save_game.dat"
var endings = []

func _ready():
	var file = File.new()
	file.open(safe_file_path, File.READ)
	var content = file.get_as_text()
	var data = JSON.parse(content).result
	file.close()
	
	if data == null: 
		data = reset_data()
	
	load_data(data)
	
	if(Global.days >= 0 or Global.hours >= 0):
		var ending = get_ending("Ending" + str(Global.ending))
		
		if(ending != null and (ending.node.locked or (Global.days < ending.node.days or (Global.days == ending.node.days and Global.hours < ending.node.hours)))):
			ending.node.set_locked(false)
			ending.node.set_time(Global.days, Global.hours)
			reload_total_time()

func get_ending(name):
	var e = null
	for ending in endings:
		if(ending.name == name): 
			e = ending
			break
	return e

func reset_data():
	return {"list": [
		{"name": "Ending1", "locked": true},
		{"name": "Ending2", "locked": true},
		{"name": "Ending3", "locked": true},
		{"name": "Ending4", "locked": true},
		{"name": "Ending5", "locked": true},
		{"name": "Ending6", "locked": true},
		{"name": "Ending7", "locked": true},
		{"name": "Ending8", "locked": true},
		{"name": "Ending9", "locked": true}
	]}

func load_data(data):
	endings = []
	
	for ending in data.list:
		var node = get_node("CanvasLayer/Panel/Endings/" + ending.name)
		if(node == null): continue
		endings.push_back({
			"node": node,
			"name": ending.name
		})
		node.set_locked(ending.locked)
		if(!node.locked): 
			node.set_time(ending.days, ending.hours)
	
	reload_total_time()

func reload_total_time():
	var days = 0
	var hours = 0
	
	for ending in endings:
		if ending.node.locked: continue
		days += ending.node.days
		hours += ending.node.hours
	
	if (hours >= 24):
		days += floor(hours/24.0)
		hours = abs(hours%24)
		
	set_total_time(days, hours)

func exit():
	var file = File.new()
	file.open(safe_file_path, File.WRITE)
	file.store_string(endings_to_data())
	file.close()
	
	get_tree().quit()

func set_total_time(days, hours):
	$CanvasLayer/Panel/TotalTime.text = "Total time: " + str(days) + " and " + str(hours) + " hours"

func endings_to_data():
	var data = {"list": []}
	
	for ending in endings:
		var item = {
			"name": ending.name,
			"locked": ending.node.locked
		}
		if(!item.locked):
			item.days = ending.node.days
			item.hours = ending.node.hours
		
		data.list.push_back(item)
	
	return JSON.print(data)

func play():
	get_tree().change_scene("res://scenes/MainScene.tscn")
	
func reset():
	load_data(reset_data())

func _on_Play_pressed():
	play()

func _on_Reset_pressed():
	reset()

func _on_Exit_pressed():
	exit()
