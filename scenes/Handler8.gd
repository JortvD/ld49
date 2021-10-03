extends Node

func _ready():
	var fire_department  = $"/root/MainScene/Buildings/FireDepartment"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var house_e = $"/root/MainScene/Buildings/HouseE"
	
	
	$"..".npc_name = "FireDepartmentWoman"
	$"..".child = self
	$"..".schedule = [
		{"at": 5, "mins": 0,  "type": "MOVE", "moves": [house_e.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 9, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), Vector2(768,2048), Vector2(2304,1024), Vector2(5376,2048), Vector2(3050,3072)]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [saloon.get_entrance_position(),saloon.get_random_spot()]},
		{"at": 15, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 18, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), Vector2(2560,550)]},
		{"at": 19, "mins": 0,  "type": "MOVE", "moves": [saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 23, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_e.get_entrance_position(), house_e.get_random_spot()]}
	]

func _story_message(id):
	pass

func _story_exit(id):
	$"..".end_conversation()

func _handle_entering_player(distance):
	$"..".show_text()
	$"..".set_text("Press SPACE to talk")

func _handle_leaving_player(distance):
	$"..".hide_text()

func _handle_custom_task(task):
	pass
