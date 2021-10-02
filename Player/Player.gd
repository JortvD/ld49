extends KinematicBody2D

export var speed = 100
export var rotation_speed = 5
var velocity = Vector2()

func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
	var target_position = get_global_mouse_position()
	
	rotation = lerp_angle(rotation, target_position.angle_to_point(global_position), rotation_speed * delta)
