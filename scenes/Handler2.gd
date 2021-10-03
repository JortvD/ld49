extends Node

var first_time = false

func _ready():
	var house_c = $"/root/MainScene/Buildings/HouseC"
	var post_man_office  = $"/root/MainScene/Buildings/Postman"
	var fire_department  = $"/root/MainScene/Buildings/FireDepartment"
	var doctor  = $"/root/MainScene/Buildings/Doctor"
	var house_a = $"/root/MainScene/Buildings/HouseA"
	var house_b = $"/root/MainScene/Buildings/HouseB"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var city_hall = $"/root/MainScene/Buildings/CityHall"
	var general_store = $"/root/MainScene/Buildings/GeneralStore"
	var house_f = $"/root/MainScene/Buildings/HouseF"
	var bank = $"/root/MainScene/Buildings/Bank"
	var sheriff = $"/root/MainScene/Buildings/Sheriff"
	var house_e = $"/root/MainScene/Buildings/HouseE"
	var house_d = $"/root/MainScene/Buildings/HouseD"
	
	
	$"..".npc_name = "Postman"
	$"..".child = self
	$"..".schedule = [
		{"at": 0, "mins": 0,  "type": "MOVE", "moves": [house_d.get_exit_position(), house_c.get_entrance_position(), house_c.get_random_spot()]},
		{"at": 6, "mins": 0,  "type": "MOVE", "moves": [house_c.get_exit_position(), post_man_office.get_entrance_position(), post_man_office.get_random_spot()]},
		{"at": 8, "mins": 0,  "type": "MOVE", "moves": [post_man_office.get_exit_position(), fire_department.get_entrance_position(),fire_department.get_random_spot()]},
		{"at": 9, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), doctor.get_entrance_position(), doctor.get_random_spot()]},
		{"at": 10, "mins": 0,  "type": "MOVE", "moves": [doctor.get_exit_position(), house_a.get_entrance_position(), house_a.get_random_spot()]},
		{"at": 11, "mins": 0,  "type": "MOVE", "moves": [house_a.get_exit_position(), house_b.get_entrance_position(), house_b.get_random_spot()]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [house_b.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 15, "mins": 0,  "type": "MOVE", "moves": [city_hall.get_exit_position(), general_store.get_entrance_position(), general_store.get_random_spot()]},
		{"at": 16, "mins": 0,  "type": "MOVE", "moves": [general_store.get_exit_position(), house_f.get_entrance_position(), house_f.get_random_spot()]},
		{"at": 17, "mins": 0,  "type": "MOVE", "moves": [house_f.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 18, "mins": 0,  "type": "MOVE", "moves": [bank.get_exit_position(), sheriff.get_entrance_position(), sheriff.get_random_spot()]},
		{"at": 19, "mins": 0,  "type": "MOVE", "moves": [sheriff.get_exit_position(), house_e.get_entrance_position(), house_e.get_random_spot()]},
		{"at": 20, "mins": 0,  "type": "MOVE", "moves": [house_e.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 23, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_d.get_entrance_position(), house_d.get_random_spot()]}
	]
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("postman-warning", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 23 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 6):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("postman-sleeping", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 8 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 12) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 14 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 20)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("postman-working", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 12 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 14) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 20 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 23)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("postman-relaxing", {"npc": $"..".names["Postman"]}, {}, self)
			$"..".start_conversation()

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
