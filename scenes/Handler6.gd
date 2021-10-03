extends Node

func _ready():
	var fire_department  = $"/root/MainScene/Buildings/FireDepartment"
	var doctor  = $"/root/MainScene/Buildings/Doctor"
	var house_a = $"/root/MainScene/Buildings/HouseA"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var general_store = $"/root/MainScene/Buildings/GeneralStore"
	var house_f = $"/root/MainScene/Buildings/HouseF"

	
	
	$"..".npc_name = "Doctor"
	$"..".child = self
	$"..".schedule = [
		{"at": 0, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_a.get_entrance_position(), house_a.get_random_spot()]},
		{"at": 8, "mins": 0,  "type": "MOVE", "moves": [house_a.get_exit_position(), general_store.get_entrance_position(), general_store.get_random_spot()]},
		{"at": 10, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), doctor.get_entrance_position(),doctor.get_random_spot()]},
		{"at": 13, "mins": 0,  "type": "MOVE", "moves": [doctor.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 15, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), doctor.get_entrance_position(), doctor.get_random_spot()]},
		{"at": 20, "mins": 0,  "type": "MOVE", "moves": [doctor.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]}
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
