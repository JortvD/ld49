extends KinematicBody2D

var DISTANCE_TO_CLOSE = 100

var child
export var rotation_speed = 5
var mood = 1
var speed = 200
var path : = PoolVector2Array()
var player_close = false
var health = 100
var interact_lock = false
onready var BULLET = preload("res://objects/Bullet.tscn")
var override_task = null
var scheduled_task = null
var in_building = null
var next_moves = []
# Mostly temporary names
var names = {
	"Mayor": "Mark",
	"Postman": "Henk",
	"Sheriff": "Frank",
	"GeneralStoreman": "Stef",
	"Bankwoman": "Leia",
	"Doctor": "Olivia",
	"FireDepartmentGuy": "Oliver",
	"FireDepartmentGirl": "Sophie",
	"OldJoe": "Old Joe",
	"SaloonOwner": "Silvia"
}
var reputation = {}

var npc_name = "Test"
var schedule = []
var last_hour = -1
var last_minutes = -1

func _ready():
	for key in names.keys():
		if(key == name): continue
		
		reputation[key] = 50
	
	reputation["Player"] = 50

func _process(delta):
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta

	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0 and !interact_lock:
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
		
	if(path.size() == 0 and len(next_moves) > 0):
		var move = next_moves.pop_front()
		path = $"/root/MainScene/Navigation2D".get_simple_path(position, move)
		print("now moving from ", position, " to ", move, " by ", path)
		$"/root/MainScene/Line2D".points = path
	
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
	
#	if mood == 1 and $BulletTimer.is_stopped():
#		npc_shoot()
#
#	var target_position = $"/root/MainScene/Player".position
#
#	rotation = lerp_angle(rotation, target_position.angle_to_point(global_position), rotation_speed * delta)
#
#	if (health <= 0):
#		npc_dead()

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
#			if(in_building != null): get_node("/root/MainScene/Buildings" + in_building + "/").
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

func npc_shoot():
	return
	var b = BULLET.instance()
	owner.add_child(b)
	b.transform = $LocationBullet.global_transform
	$BulletTimer.start()
	
func npc_dead():
	mood = -1
	speed = 0
	rotation_speed = 0
