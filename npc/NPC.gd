extends KinematicBody2D

var DISTANCE_TO_CLOSE = 100

export var rotation_speed = 5
export(SpriteFrames) var shoulders
export(Texture) var hat

var child
enum MOOD {DEFAULT = 0, ATTACK = 1, BLOODTHIRST = 2, DERANGED = 3}
var mood = MOOD.DEFAULT
var speed = 200
var path : = PoolVector2Array()
var player_close = false
var health = 100
var deranged_speed = 1
var dead = false
var interact_lock = false
onready var BULLET = preload("res://objects/Bullet.tscn")
onready var saloon  = $"/root/MainScene/Buildings/Saloon"
var deranged_positions = [Vector2(1000, 2100), Vector2(2400, 1000), Vector2(5500, 2200), Vector2(3000, 3000)]

var override_task = null
var scheduled_task = null
var last_hour = -1
var last_minutes = -1
var walking = false
export(String) var in_building
var next_moves = []
var followClose = false
var followDistance = 300
var fireDistance = 100
var fightFire = false
# Mostly temporary names
var names = {
	"Mayor": "Mark",
	"Postman": "Henk",
	"Sheriff": "Frank",
	"GeneralStoreman": "Stef",
	"BankWoman": "Leia",
	"Doctor": "Olivia",
	"FireDepartmentMan": "Oliver",
	"FireDepartmentWoman": "Sophie",
	"OldJoe": "Old Joe",
	"SaloonOwner": "Silvia"
}
var reputation = {}
var target = null

var npc_name = "Test"
var schedule = []
var can_attack = false
var weapon = null

func _ready():
	if hat != null: $Sprite.texture = hat 
	if shoulders != null: $AnimatedSprite.frames = shoulders 
	
	for key in names.keys():
		if(key == name): continue
		
		reputation[key] = 50
	
	reputation["Player"] = 50

func _process(delta):
	# Death
	if(health <= 0):
		dead = true
		return
	
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta * deranged_speed
	
	if(mood == MOOD.DERANGED and $DerangedTimer.is_stopped()):
		deranged_speed = randf()
		$DerangedTimer.start()
		
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0 and !interact_lock:
		walking = true
		if($AnimatedSprite.frames != null): $AnimatedSprite.play("walking")
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
		
		if(len(path) > 0): rotation = position.angle_to_point(path[0]) + PI
	
	if($FireTimer.is_stopped() and fightFire and mood == MOOD.DEFAULT and in_building == null):
		var fire = find_fire()
		var to = position.direction_to(fire.global_position) * (position.distance_to(fire.global_position) - fireDistance) + position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
		next_moves = [to]
		path = PoolVector2Array()
		$FireTimer.start()
	
	if($FollowTimer.is_stopped() and mood == MOOD.ATTACK):
		if(followClose):
			next_moves = [target.global_position]
		else:
			var to = position.direction_to(target.global_position) * (position.distance_to(target.global_position) - followDistance) + position
			next_moves = [to]
		path = PoolVector2Array()
		$FollowTimer.start()
	
	if(mood == MOOD.ATTACK):
		rotation = lerp_angle(rotation, target.position.angle_to_point(global_position), rotation_speed * delta)
		
	if(path.size() == 0):
		if(len(next_moves) > 0):
			var move = next_moves.pop_front()
			path = $"/root/MainScene/Navigation2D".get_simple_path(position, move)
		elif(walking):
			walking = false
			if($AnimatedSprite.frames != null): $AnimatedSprite.play("default")
			
	if(mood == MOOD.ATTACK and len(path) == 0):
		override_task == null
		mood = MOOD.DEFAULT
	
	if mood == MOOD.DERANGED:
		schedule = [
			{"at": 2, "mins": 0, "type": "MOVE", "moves": [saloon.get_exit_position(), deranged_positions[randi() % deranged_positions.size()]]},
			{"at": 4, "mins": 0, "type": "MOVE", "moves": [deranged_positions[randi() % deranged_positions.size()]], "force_outside": true},
			{"at": 6, "mins": 0, "type": "MOVE", "moves": [deranged_positions[randi() % deranged_positions.size()]], "force_outside": true},
			{"at": 8, "mins": 0, "type": "MOVE", "moves": [saloon.get_entrance_position(), saloon.get_random_spot()], "force_outside": true}
		]
	
	if($AttackTimer.is_stopped()):
		var seen = $"/root/MainScene".check_npc_rays(name)
		if(mood == MOOD.ATTACK): mood = MOOD.DEFAULT 
		for c in seen.keys():
			if(c == name): continue;
			#print(c, " ", seen[c], " ", reputation[c], can_attack, weapon)
			if(seen[c] and reputation[c] <= 0 and can_attack and weapon != null):
				mood = MOOD.ATTACK
				handle_override_task({"type": "FOLLOW_CLOSE" if weapon.action == "STAB" else "FOLLOW_DISTANT", "target": c})
				break
		$AttackTimer.start()
		
	if(weapon != null):
		if(mood == MOOD.ATTACK or mood == MOOD.BLOODTHIRST):
			$Holster.visible = false
			$Holding.visible = true
		else:
			$Holster.visible = true
			$Holding.visible = false
	else:
		$Holster.visible = false
		$Holding.visible = false
		
	if(mood == MOOD.ATTACK and $BulletTimer.is_stopped()):
		attack()
		$BulletTimer.wait_time = 1 / weapon.options.rps
		$BulletTimer.start()
	
	var hour = $"/root/MainScene/CanvasLayer/DayNightCycle".hour
	var minutes = $"/root/MainScene/CanvasLayer/DayNightCycle".minutes
	
	if(hour != last_hour or minutes != last_minutes):
		last_hour = hour
		last_minutes = minutes
		
		var task = find_task_at(hour, minutes)
		
		if(task != null):
			handle_scheduled_task(task)
	
	var distance = position.distance_to($"/root/MainScene/Player".position)
	if distance <= DISTANCE_TO_CLOSE:
		if !player_close: 
			player_close = true
			#child._handle_entering_player(distance)
	else:
		if player_close:
			player_close = false
			#child._handle_leaving_player(distance)

func attack():
	if weapon.action == "STAB":
		stab()
	else:
		shoot()

func find_fire():
	for node in $"/root/MainScene/World".get_children():
		if("Fire" in node.name): return node

func handle_scheduled_task(task):
	scheduled_task = task
	
	if(override_task != null): return
	
	handle_task(task)
	
func handle_override_task(task):
	override_task = task
	
	handle_task(task)

func handle_task(task):
	match task.type:
		"MOVE":
			next_moves = task.moves
			if(in_building != null and "force_outside" in task and task["force_outside"]): next_moves.push_front(get_node("/root/MainScene/Buildings/" + in_building + "/").get_exit_position())
		"FOLLOW_DISTANT":
			followClose = false
			if(task.target == "Player"): target = $"/root/MainScene/Player"
			else: target = get_node("../" + task.target)
		"FOLLOW_CLOSE":
			followClose = true
			if(task.target == "Player"): target = $"/root/MainScene/Player"
			else: target = get_node("../" + task.target)
		"EXTINGUISH_FIRE":
			if(in_building != null and "force_outside" in task and task["force_outside"]): next_moves.push_front(get_node("/root/MainScene/Buildings/" + in_building + "/").get_exit_position())
			fightFire = true
		_:
			child._handle_custom_task(task)

func find_task_at(hour, minutes):
	for i in schedule:
		if(i["at"] == hour and i["mins"] == minutes): return i

func start_conversation():
	$"/root/MainScene/Player".interact_lock = true
	interact_lock = true
	
func end_conversation():
	$"/root/MainScene/Player".interact_lock = false
	interact_lock = false

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

func stab():
	if(position.distance_to(target.global_position) > 100): return
	if(position.angle_to(target.global_position) > .5*PI): return
	
	target.health -= weapon.options.damage

func shoot():
	if(!$"/root/MainScene".check_ray(self, target)): return
	
	var b = BULLET.instance()
	owner.add_child(b)
	b.transform = $LocationBullet.global_transform
	
func npc_dead():
#	mood = -1
	speed = 0
	rotation_speed = 0
	dead = true
