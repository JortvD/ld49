extends Node2D

var mounted = false
var horse_modifier = 1
var DISTANCE_TO_CLOSE = 100
var player_close

func _input(event):
	if Input.is_action_pressed("ui_g") and player_close:
		if not mounted:
			horse_modifier = 2
			mounted = true
		else:
			horse_modifier = 1
			mounted = false

func _process(delta):
	var distance = position.distance_to($"/root/MainScene/Player".position)
	if distance <= DISTANCE_TO_CLOSE:
		if !player_close: 
			player_close = true
	else:
		if player_close:
			player_close = false

