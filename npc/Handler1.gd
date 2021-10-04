extends Node

var first_time

onready var dialog = $"/root/MainScene/CanvasLayer/Dialog"
onready var day_night_cycle = $"/root/MainScene/CanvasLayer/DayNightCycle"
onready var player = $"/root/MainScene/Player"

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
			dialog.start_story("mayor-intro", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour == 7:
			dialog.start_story("mayor-walking", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 14 and day_night_cycle.hour < 18 and not player.city_money == 0:
			dialog.start_story("mayor-bribing", {"npc": $"..".names["Mayor"]}, {"money": $"/root/MainScene/Player".money, "reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 14 and day_night_cycle.hour < 18 and $"/root/MainScene/Player".city_money == 0:
			dialog.start_story("mayor-buying-city", {"npc": $"..".names["Mayor"]}, {"money": $"/root/MainScene/Player".money, "reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 18 and day_night_cycle.hour < 19:
			dialog.start_story("mayor-bank", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 2 and day_night_cycle.hour < 8:
			dialog.start_story("mayor-sleeping", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 2 and day_night_cycle.hour < 8:
			dialog.start_story("mayor-sleeping", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 8 and day_night_cycle.hour < 12:
			dialog.start_story("mayor-working", {"npc": $"..".names["Mayor"]}, {"reputation": $"..".reputation["Player"]}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and day_night_cycle.hour >= 12 and day_night_cycle.hour < 14:
			dialog.start_story("mayor-relaxing", {"npc": $"..".names["Mayor"]}, {}, self)
			$"..".start_conversation()
		if event.scancode == KEY_SPACE and (day_night_cycle.hour >= 19 or day_night_cycle.hour < 2):
			dialog.start_story("mayor-relaxing", {"npc": $"..".names["Mayor"]}, {}, self)
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
