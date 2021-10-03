extends Node

func _ready():
	var house_d = $"/root/MainScene/Buildings/HouseD"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var general_store = $"/root/MainScene/Buildings/GeneralStore"
	var bank = $"/root/MainScene/Buildings/Bank"

	
	
	$"..".npc_name = "SaloonOwner"
	$"..".child = self
	$"..".schedule = [
		{"at": 4, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_d.get_entrance_position(), house_d.get_random_spot()]},
		{"at": 10, "mins": 0,  "type": "MOVE", "moves": [house_d.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 16, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), bank.get_entrance_position(),bank.get_random_spot()]},
		{"at": 17, "mins": 0,  "type": "MOVE", "moves": [bank.get_exit_position(), general_store.get_entrance_position(), general_store.get_random_spot()]},
		{"at": 18, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]}
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
