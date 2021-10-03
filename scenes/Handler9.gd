extends Node

func _ready():
	var fire_department  = $"/root/MainScene/Buildings/FireDepartment"
	var general_store = $"/root/MainScene/Buildings/GeneralStore"
	var house_d = $"/root/MainScene/Buildings/HouseD"
	
	
	$"..".npc_name = "Old Joe"
	$"..".child = self
	$"..".schedule = [
		{"at": 2, "mins": 0,  "type": "MOVE", "moves": [house_d.get_entrance_position(), house_d.get_random_spot()]},
		{"at": 11, "mins": 0,  "type": "MOVE", "moves": [house_d.get_exit_position(), Vector2(2560,600)]},
		{"at": 19, "mins": 0,  "type": "MOVE", "moves": [general_store.get_entrance_position(),general_store.get_random_spot()]},
		{"at": 21, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), Vector2(2560,600)]}
	]

func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("OldJoe", {"npc": $"..".names["OldJoe"]}, {"hour": $"/root/MainScene/CanvasLayer/DayNightCycle".hour, "alcohol": $"/root/MainScene/Player".alcohol}, self)
			$"..".start_conversation()

func _story_message(id):
	pass

func _story_exit(id):
	$"..".end_conversation()
