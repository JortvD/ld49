extends KinematicBody2D

var DISTANCE_TO_CLOSE = 100

var child
var speed = 50
var path : = PoolVector2Array()
var player_close = false

func _process(delta):
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta

	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point
	
	var distance = position.distance_to($"/root/MainScene/Player".position)
	if distance <= DISTANCE_TO_CLOSE:
		if !player_close: 
			player_close = true
			child._handle_entering_player(distance)
	else:
		if player_close:
			player_close = false
			child._handle_leaving_player(distance)

func _story_message(id):
	child._story_message(id)

func _story_exit(id):
	child._story_exit(id)

func show_text():
	$Label.visible = true
	
func hide_text():
	$Label.visible = false

func set_text(text):
	$Label.text = text
