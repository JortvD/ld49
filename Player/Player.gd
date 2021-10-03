extends KinematicBody2D

const INVENTORY_SIZE = 5

export var speed = 100
export var rotation_speed = 5
var horse_modifier = 2
var velocity = Vector2()
var health = 100
var health_max = 100
var inventory = []
var selected_slot = 0
var interact_lock = false
onready var BULLET = preload("res://objects/Bullet.tscn")
var throw_start = 0

var alcohol = 1
var money = 0
var city_money = 0

func _ready():
	for n in range(INVENTORY_SIZE):
		inventory.push_back(null)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			$"/root/MainScene/Items".create_item_for_player("gun", $LocationBullet.global_transform, self, 1000)
	if Input.is_action_just_pressed("ui_scroll_down"):
		selected_slot = (selected_slot+1)%INVENTORY_SIZE
		if(selected_slot < 0): selected_slot += 5
		switch_holding()
	if Input.is_action_just_pressed("ui_scroll_up"):
		selected_slot = (selected_slot-1)%INVENTORY_SIZE
		if(selected_slot < 0): selected_slot += 5
		switch_holding()

func get_input(multi):
	velocity = Vector2()
	
	if(interact_lock):
		return
	
	if Input.is_action_pressed("ui_left_click"):
		interact()
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_d"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_a"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_s"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_w"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_q"):
		if (throw_start == 0): throw_start = OS.get_ticks_msec()
	if Input.is_action_just_released("ui_q"):
		var diff = OS.get_ticks_msec()-throw_start
		throw_start = 0
		if diff>1000: diff = 1000
		throw(selected_slot, diff)
	
	if Input.is_action_pressed("ui_shift"):
		speed = 300 * horse_modifier
	else:
		speed = 100 * horse_modifier
	
	velocity = velocity.normalized() * speed * multi

func modulo(a, n):
	return a - floor(a/n) * n

func _process(delta):
	var target_position = get_global_mouse_position()
	rotation = lerp_angle(rotation, target_position.angle_to_point(global_position), rotation_speed * delta)
	
	var good_direction = abs(atan2(sin(target_position.angle_to_point(global_position)-velocity.angle()), cos(target_position.angle_to_point(global_position)-velocity.angle())))
	
	get_input(1 - (good_direction / PI) * .5)
	velocity = move_and_slide(velocity)
	
	if (health <= 0):
		playerDead();
	
	$"/root/MainScene/CanvasLayer/GUI".set_health(health, health_max)
	
	horse_modifier = $"../Horse".horse_modifier
	
	if $"../Horse".mounted:
		$"../Horse".position = self.position
	
func playerDead():
	get_tree().reload_current_scene()
	
func shoot(options):
	var b = BULLET.instance()
	b.damage = options.damage
	b.speed = options.speed
	b.get_node("Sprite").texture = load(options.img)
	owner.add_child(b)
	b.transform = $LocationBullet.global_transform
	$BulletTimer.wait_time = 1.0 / options.rps
	$BulletTimer.start()

func pickup(item):
	for n in range(INVENTORY_SIZE):
		if(inventory[n] == null):
			inventory[n] = item
			
			switch_holding()
			
			return true
	
	return false

func throw(slot, weight):
	if(inventory[slot] == null): return
	
	var item = inventory[slot]
	
	$"/root/MainScene/Items".create_item_for_player(item.name, $LocationBullet.global_transform, self, weight)
	
	inventory[slot] = null
	
	switch_holding()

func interact():
	var item = inventory[selected_slot]
	
	if(item == null): return
	
	var options = item.options
	
	match item.action:
		"SHOOT":
			if $BulletTimer.is_stopped(): shoot(options)

func switch_holding():
	$"/root/MainScene/CanvasLayer/GUI".update()
	
	if(inventory[selected_slot] == null): 
		$Item.visible = false
	else:
		$Item.texture = load(inventory[selected_slot].img)
		$Item.visible = true
	
	var next_slot = (selected_slot+1)%INVENTORY_SIZE
	if(next_slot < 0): next_slot += 5
	
	if(inventory[next_slot] == null):
		$Holster.visible = false
	else:
		$Holster.texture = load(inventory[next_slot].img)
		$Holster.visible = true
