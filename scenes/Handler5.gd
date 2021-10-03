extends Node

func _ready():
	var doctor  = $"/root/MainScene/Buildings/Doctor"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var city_hall = $"/root/MainScene/Buildings/CityHall"
	var house_f = $"/root/MainScene/Buildings/HouseF"
	var bank = $"/root/MainScene/Buildings/Bank"
	
	
	$"..".npc_name = "BankWoman"
	$"..".child = self
	$"..".schedule = [
		{"at": 1, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_f.get_entrance_position(), house_f.get_random_spot()]},
		{"at": 6, "mins": 0,  "type": "MOVE", "moves": [house_f.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 9, "mins": 0,  "type": "MOVE", "moves": [bank.get_exit_position(), city_hall.get_entrance_position(),city_hall.get_random_spot()]},
		{"at": 10, "mins": 0,  "type": "MOVE", "moves": [city_hall.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [bank.get_exit_position(), city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 13, "mins": 0,  "type": "MOVE", "moves": [city_hall.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 15, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), doctor.get_entrance_position(), doctor.get_random_spot()]},
		{"at": 16, "mins": 0,  "type": "MOVE", "moves": [doctor.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 21, "mins": 0,  "type": "MOVE", "moves": [bank.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]}
	]
