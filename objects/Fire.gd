extends Node2D

var rng = RandomNumberGenerator.new()
var FIRE = load("res://objects/Fire.tscn")
var northFire
var eastFire
var southFire
var westFire
var sidesFire = [false, false, false, false]
var PEOPLE_CLOSE = 300

func _ready():
	rng.randomize()
	$Timer.start() 

func _on_CollisionShape2D_body_entered(body):
	if (body.name == "Player"):
		get_node("../../Player").health -= 10
		print(get_node("../../Player").health)
	
func _process(delta):
	if ($Timer.is_stopped()):
		var result = check_remove()
		if !result: spread()
		$Timer.start()

func check_remove():
	var fire_department_close = false
	
	for npc in $"/root/MainScene/NPCs".get_children():
		if(npc.fightFire and position.distance_to(npc.global_position) <= PEOPLE_CLOSE):
			fire_department_close = true
	
	if(fire_department_close and rng.randi_range(1, 2) == 1):
		queue_free()
		return true
		
	return false

func spread():
	if (rng.randi_range(1, 10) == 1):
		var side = rng.randi_range(1, 4)
		if (side == 1 and !checklocation(1)):
			var f = FIRE.instance()
			$"..".add_child(f)
			f.position = self.position
			f.position.x += 64
		if (side == 2 and !checklocation(3)):
			var f = FIRE.instance()
			$"..".add_child(f)
			f.position = self.position
			f.position.x -= 64
		if (side == 3 and !checklocation(2)):
			var f = FIRE.instance()
			$"..".add_child(f)
			f.position = self.position
			f.position.y += 64
		if (side == 4 and !checklocation(0)):
			var f = FIRE.instance()
			$"..".add_child(f)
			f.position = self.position
			f.position.y -= 64
			
func checklocation(side):
	var areas = get_node("Check" + str(side + 1)).get_overlapping_areas()
	
	for area in areas:
		if("Fire" in area.get_parent().name):
			sidesFire[side] = true
			return true
		
	return false
