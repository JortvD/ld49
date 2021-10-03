extends Node

func _ready():
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var general_store = $"/root/MainScene/Buildings/GeneralStore"
	var house_f = $"/root/MainScene/Buildings/HouseF"
	
	
	$"..".npc_name = "GeneralStoreman"
	$"..".child = self
	$"..".schedule = [
		{"at": 7, "mins": 0,  "type": "MOVE", "moves": [house_f.get_exit_position(), general_store.get_entrance_position(), general_store.get_random_spot()]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), general_store.get_entrance_position(),general_store.get_random_spot()]},
		{"at": 21, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), house_f.get_entrance_position(), house_f.get_random_spot()]}
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
