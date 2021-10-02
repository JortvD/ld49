extends Node

func _ready():
	$"..".child = self
	
func _input(event):
	if event is InputEventKey and event.pressed and $"..".player_close:
		if event.scancode == KEY_SPACE:
			$"/root/MainScene/CanvasLayer/Dialog".start_story("test", {"name": "Jort"}, {"lifes": 5}, self)

func _story_message(id):
	pass

func _story_exit(id):
	pass

func _handle_entering_player(distance):
	$"..".show_text()
	$"..".set_text("Press SPACE")

func _handle_leaving_player(distance):
	$"..".hide_text()
