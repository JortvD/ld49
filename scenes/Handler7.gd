extends Node

func _ready():
	var fire_department  = $"/root/MainScene/Buildings/FireDepartment"
	var doctor  = $"/root/MainScene/Buildings/Doctor"
	var house_a = $"/root/MainScene/Buildings/HouseA"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var sheriff = $"/root/MainScene/Buildings/Sheriff"
	var house_e = $"/root/MainScene/Buildings/HouseE"
	var house_d = $"/root/MainScene/Buildings/HouseD"
	
	
	$"..".npc_name = "FireDepartmentMan"
	$"..".child = self
	$"..".schedule = [
		{"at": 6, "mins": 0,  "type": "MOVE", "moves": [house_a.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 9, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), sheriff.get_entrance_position(), sheriff.get_random_spot()]},
		{"at": 11, "mins": 0,  "type": "MOVE", "moves": [sheriff.get_exit_position(), doctor.get_entrance_position(),doctor.get_random_spot()]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [doctor.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 19, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), Vector2(768,2048), Vector2(2304,1024), Vector2(5376,2048), Vector2(3050,3072)]},
		{"at": 21, "mins": 0,  "type": "MOVE", "moves": [saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 22, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_a.get_entrance_position(), house_a.get_random_spot()]}
	]

func _story_message(id, story):
	pass

func _story_exit(id, story):
	$"..".end_conversation()

func _handle_entering_player(distance):
	$"..".show_text()
	$"..".set_text("Press SPACE to talk")

func _handle_leaving_player(distance):
	$"..".hide_text()

func _handle_custom_task(task):
	pass
