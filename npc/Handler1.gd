extends Node

var first_time

func _ready():
	var house_b = $"/root/MainScene/Buildings/HouseB"
	var city_hall  = $"/root/MainScene/Buildings/CityHall"
	var saloon  = $"/root/MainScene/Buildings/Saloon"
	var bank  = $"/root/MainScene/Buildings/Bank"
	
	first_time = false
	
	$"..".npc_name = "Mayor"
	$"..".child = self
	$"..".schedule = [
		{"at": 2, "mins": 0, "type": "MOVE", "moves": [house_b.get_entrance_position(), house_b.get_random_spot()]},
		{"at": 7, "mins": 0, "type": "MOVE", "moves": [house_b.get_exit_position(), Vector2(2000, 2200)]},
		{"at": 8, "mins": 0, "type": "MOVE", "moves": [city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 12, "mins": 0, "type": "MOVE", "moves": [city_hall.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "mins": 0, "type": "MOVE", "moves": [saloon.get_exit_position(), city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 18, "mins": 0, "type": "MOVE", "moves": [city_hall.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 19, "mins": 0, "type": "MOVE", "moves": [bank.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]}
	]
	$"..".weapon = $"/root/MainScene/Items".get_type("gun")
	$"..".can_attack = true
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE and not first_time:
			first_time = true
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-intro", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour == 7:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-walking", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 14 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 18 and not $"/root/MainScene/Player".city_money == 0:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-bribing", {"npc": $"..".names["Mayor"]}, {"money": $"/root/MainScene/Player".money, "reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 14 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 18 and $"/root/MainScene/Player".city_money == 0:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-buying-city", {"npc": $"..".names["Mayor"]}, {"money": $"/root/MainScene/Player".money, "reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 18 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 19:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-bank", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 2 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 8:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-sleeping", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 2 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 8:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-sleeping", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 8 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 12:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-working", {"npc": $"..".names["Mayor"]}, {"reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and $"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 12 and $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 14:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-relaxing", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and ($"/root/MainScene/CanvasLayer/DayNightCycle".hour >= 19 or $"/root/MainScene/CanvasLayer/DayNightCycle".hour < 2):
			$"/root/MainScene/CanvasLayer/Dialog".start_story("mayor-relaxing", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		

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
