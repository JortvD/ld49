extends Node2D

# this handles all the pathfinding for all entities. first if statements explains all components
func _unhandled_input(event):
		if Input.is_action_pressed("ui_1"):		#requirement for going to the position
			var path = $Navigation2D.get_simple_path($NPC.position, Vector2(-192,-192)) # position it will go to
			$Line2D.points = path	#TESTING PURPOSES creates line showing its path
			$NPC.path = path		#creates the path for the entity
		if Input.is_action_pressed("ui_2"):
			var path = $Navigation2D.get_simple_path($NPC.position, Vector2(256,192))
			$Line2D.points = path
			$NPC.path = path

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			$"CanvasLayer/Dialog".start_story("test", {"name": "Jort"}, {"lifes": 5}, self)
		
func _story_message(i):
	pass

func _story_exit(i):
	pass
