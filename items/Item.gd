extends RigidBody2D

var DISTANCE_TO_CLOSE = 100
var player_close = false

var type

func _process(delta):
	var distance = position.distance_to($"/root/MainScene/Player".position)
	if distance <= DISTANCE_TO_CLOSE:
		if !player_close: 
			player_close = true
	else:
		if player_close:
			player_close = false

func _input(event):
	if event is InputEventKey and event.pressed and player_close and Input.is_action_pressed("ui_e"):
		var result = $"/root/MainScene/Player".pickup(type)
		if result: queue_free()
