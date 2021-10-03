extends Node

func _ready():
	var house_b = $"/root/MainScene/Buildings/HouseB"
	var city_hall  = $"/root/MainScene/Buildings/CityHall"
	var saloon  = $"/root/MainScene/Buildings/Saloon"
	var bank  = $"/root/MainScene/Buildings/Bank"
	
	$"..".npc_name = "Mayor"
	$"..".child = self
	$"..".schedule = [
		{"at": 2, "type": "MOVE", "moves": [house_b.get_entrance_position(), house_b.get_random_spot()]},
		{"at": 7, "type": "MOVE", "moves": [house_b.get_exit_position(), Vector2(2000, 2200)]},
		{"at": 8, "type": "MOVE", "moves": [city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 12, "type": "MOVE", "moves": [city_hall.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]},
		{"at": 14, "type": "MOVE", "moves": [saloon.get_exit_position(), city_hall.get_entrance_position(), city_hall.get_random_spot()]},
		{"at": 18, "type": "MOVE", "moves": [city_hall.get_exit_position(), bank.get_entrance_position(), bank.get_random_spot()]},
		{"at": 19, "type": "MOVE", "moves": [bank.get_exit_position(), saloon.get_entrance_position(), saloon.get_random_spot()]}
	]
	
#func _input(event):
#	if event is InputEventKey and event.pressed and $"..".player_close:
#		if event.scancode == KEY_SPACE:
#			$"/root/MainScene/CanvasLayer/Dialog".start_story("test", {"name": "Jort"}, {"lifes": 5}, self)
#			$"..".start_conversation()

func _story_message(id):
	pass

func _story_exit(id):
	$"..".end_conversation()

func _handle_entering_player(distance):
	$"..".show_text()
	$"..".set_text("Press SPACE")

func _handle_leaving_player(distance):
	$"..".hide_text()

func _handle_custom_task(task):
	pass
