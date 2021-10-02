extends KinematicBody2D

var DISTANCE_TO_CLOSE = 100

var child
export var rotation_speed = 5
var mood = 0
var speed = 50
var path : = PoolVector2Array()
var player_close = false
onready var BULLET = preload("res://objects/Bullet.tscn")

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
	
	if mood == 1 and $BulletTimer.is_stopped():
		npc_shoot()
		
	var target_position = $"/root/MainScene/Player".position
	
	rotation = lerp_angle(rotation, target_position.angle_to_point(global_position), rotation_speed * delta)
		

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

func npc_shoot():
	var b = BULLET.instance()
	owner.add_child(b)
	b.transform = $LocationBullet.global_transform
	$BulletTimer.start()
