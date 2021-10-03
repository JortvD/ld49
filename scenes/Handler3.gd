extends Node

func _ready():
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var city_hall = $"/root/MainScene/Buildings/CityHall"
	var bank = $"/root/MainScene/Buildings/Bank"
	var sheriff = $"/root/MainScene/Buildings/Sheriff"
	var house_e = $"/root/MainScene/Buildings/HouseE"
	var player = $"/root/MainScene/Player"

	
	
	$"..".npc_name = "Sheriff"
	$"..".child = self
	$"..".schedule = [
		{"at": 7, "type": "MOVE", "moves": [house_e.get_exit_position(), sheriff.get_entrance_position(), sheriff.get_random_spot()]},
		{"at": 9, "type": "MOVE", "moves": [sheriff.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 10, "type": "MOVE", "moves": [bank.get_exit_position(), sheriff.get_entrance_position(),sheriff.get_random_spot()]},
		{"at": 12, "type": "MOVE", "moves": [sheriff.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "type": "MOVE", "moves": [saloon.get_exit_position(), player.position, player.position]},
		{"at": 17, "type": "MOVE", "moves": [sheriff.get_entrance_position(), sheriff.get_random_spot()]},
		{"at": 20, "type": "MOVE", "moves": [sheriff.get_exit_position(), city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 21, "type": "MOVE", "moves": [city_hall.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 23, "type": "MOVE", "moves": [saloon.get_exit_position(), house_e.get_entrance_position(), house_e.get_random_spot()]}
	]
