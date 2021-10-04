extends Node

var first_time = false

func _ready():
	var fire_department  = $"/root/MainScene/Buildings/FireDepartment"
	var saloon = $"/root/MainScene/Buildings/Saloon"
	var house_e = $"/root/MainScene/Buildings/HouseE"
	
	
	$"..".npc_name = "FireDepartmentWoman"
	$"..".child = self
	$"..".schedule = [
		{"at": 5, "mins": 0,  "type": "MOVE", "moves": [house_e.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 9, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), Vector2(768,2048), Vector2(2304,1024), Vector2(5376,2048), Vector2(3050,3072)]},
		{"at": 12, "mins": 0,  "type": "MOVE", "moves": [saloon.get_entrance_position(),saloon.get_random_spot()]},
		{"at": 15, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), fire_department.get_entrance_position(), fire_department.get_random_spot()]},
		{"at": 18, "mins": 0,  "type": "MOVE", "moves": [fire_department.get_exit_position(), Vector2(2560,550)]},
		{"at": 19, "mins": 0,  "type": "MOVE", "moves": [saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 23, "mins": 0,  "type": "MOVE", "moves": [saloon.get_exit_position(), house_e.get_entrance_position(), house_e.get_random_spot()]}
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
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("firedepartmentman-first-time", {"npc": $"..".names["Firedepartment Man"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 5 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 9) or ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 15 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 18)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("firedepartment-working", {"npc": $"..".names["Firedepartment Man"]}, {"apple": $"/root/MainScene/Player".apple, "apple pie": $"/root/MainScene/Player".applepie}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 0 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 8):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("firedepartment-sleeping", {"npc": $"..".names["Firedepartment Man"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 20 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 0):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("firedepartment-relaxing", {"npc": $"..".names["Firedepartment Man"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 8 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 10)):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("firedepartment-walking", {"npc": $"..".names["Firedepartment Man"]}, {}, self)
			$"..".start_conversation()

