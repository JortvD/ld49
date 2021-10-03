extends Node

var first_time = false

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
		{"at": 7, "mins": 0,  "type": "MOVE", "moves": [house_e.get_exit_position(), sheriff.get_entrance_position(), sheriff.get_random_spot()]},
		{"at": 9, "mins": 0,  "type": "MOVE", "moves": [sheriff.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 10, "mins": 0,  "type": "MOVE", "moves": [bank.get_exit_position(), sheriff.get_entrance_position(),sheriff.get_random_spot()]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [sheriff.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), player.position, player.position]},
		{"at": 17, "mins": 0,  "type": "MOVE", "moves": [sheriff.get_entrance_position(), sheriff.get_random_spot()]},
		{"at": 20, "mins": 0,  "type": "MOVE", "moves": [sheriff.get_exit_position(), city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 21, "mins": 0,  "type": "MOVE", "moves": [city_hall.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 23, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_e.get_entrance_position(), house_e.get_random_spot()]}
	]

func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("sheriff-first-time", {"npc": $"..".names["Sheriff"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 23 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 7):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("sheriff-sleeping", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 7 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 9) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 10 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 12) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 17 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 20)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("sheriff-working", {"npc": $"..".names["Postman"]}, {"reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour == 9:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("sheriff-bank", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 14 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 17)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("sherrif-following", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 20 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 21)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("sherrif-city-hall", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()

