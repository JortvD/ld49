extends KinematicBody2D

export var speed = 100
export var rotation_speed = 5
var velocity = Vector2()
var health = 100
var reputation_rojo = 50
var reputation_Arizona = 50
onready var BULLET = preload("res://objects/Bullet.tscn")

func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_q"):
		shoot()
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_d"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_a"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_s"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_w"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_shift"):
		speed = 300
	else:
		speed = 100
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
	var target_position = get_global_mouse_position()
	
	rotation = lerp_angle(rotation, target_position.angle_to_point(global_position), rotation_speed * delta)
	
	if (health <= 0):
		playerDead();
	
func playerDead():
	get_tree().reload_current_scene()
	
func shoot():
	var b = BULLET.instance()
	owner.add_child(b)
	b.transform = self.global_transform
	

