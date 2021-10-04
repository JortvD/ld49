extends Node

var first_time = false

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
	$"..".weapon = $"/root/MainScene/Items".get_type("knife")
	$"..".can_attack = true
	$".."._load_graphics()

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
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("doctor-first-time", {"npc": $"..".names["Doctor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 10 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 13) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 15 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 20)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("doctor-working", {"npc": $"..".names["Doctor"]}, {"apple": $"/root/MainScene/Player".apple, "apple pie": $"/root/MainScene/Player".applepie}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 0 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 8):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("doctor-sleeping", {"npc": $"..".names["Doctor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 20 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 0):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("doctor-relaxing", {"npc": $"..".names["Doctor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 8 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 10)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("doctor-generalstore", {"npc": $"..".names["doctor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 14 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 15):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("doctor-firedepartment", {"npc": $"..".names["doctor"]}, {}, self)
			$"..".start_conversation()
