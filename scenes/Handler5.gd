extends Node

var first_time

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
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("bankwoman-first-time", {"npc": $"..".names["BankWoman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 6 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 9) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 10 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 12) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 16 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 21)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("bankwoman-working", {"npc": $"..".names["BankWoman"]}, {"money": $"/root/MainScene/Player".money, "reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 1 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 6):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("bankwoman-sleeping", {"npc": $"..".names["BankWoman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 21 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 1):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("bankwoman-relaxing", {"npc": $"..".names["BankWoman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 9 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 10) and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 12 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 13)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("bankwoman-city-hall", {"npc": $"..".names["BankWoman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 15 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 16):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("bankwoman-doctor", {"npc": $"..".names["BankWoman"]}, {}, self)
			$"..".start_conversation()
