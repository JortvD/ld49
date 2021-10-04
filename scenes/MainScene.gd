extends Node2D

var ending = 0
var MAX_FIRES = 1000
var MAX_SEEN_DISTANCE = 300

var city = {
	"unplaced_money": 4,
	"bankrupt": false,
	"post_efficiency": 1
}

var bank_money = [null, null]
var last_hour = -1
var rob_checks = []
var del_checks = []
var bodies_discovery = {}
onready var FIRE = preload("res://objects/Fire.tscn")
var days_disconnected = 0

func _ready():
	$Items.create_item("gun", Vector2(5250, -1250))
	$Items.create_item("knife", Vector2(3750, -1300))

func _process(delta):
	# Every hour
	if($CanvasLayer/DayNightCycle.hour != last_hour):
		last_hour = $CanvasLayer/DayNightCycle.hour
		hour_events(last_hour)
		
		if(!check_ray($Player, $NPCs/Postman)): check_postman_efficiency()
		
	if($Timers/RobbedTimer.is_stopped()):
		for rob_check in rob_checks:
			if(rob_check["building"] == $Player.in_building):
				var seen = check_player_rays()
				var is_seen = false
				
				for player in seen.keys():
					if(seen[player] == false): continue
					is_seen = true
					get_node("NPCs/" + player).reputation["Player"] -= rob_check["finder_decrease"]
				
				if is_seen:
					get_node("NPCs/" + rob_check["owner"]).reputation["Player"] -= rob_check["owner_decrease"]
					decrease_all_reputations(rob_check["global_decrease"], "Player", [rob_check["owner"]])
			
			rob_check["i"] -= 1;
			if(rob_check["i"] == 0): rob_checks.erase(rob_check)
		$Timers/RobbedTimer.start()
	
	if $Timers/KillTimer.is_stopped():
		for c in $NPCs.get_children():
			if(c.health <= 0):
				c.dead_timer += 1
		$Timers/KillTimer.start()
	
	if $Timers/BodyTimer.is_stopped():
		for c in $NPCs.get_children():
			if(c.health <= 0 and !(c.name in bodies_discovery)):
				bodies_discovery[c.name] = false
		
		for body in bodies_discovery.keys():
			if(!bodies_discovery[body]):
				var seen = false
				var check = check_npc_rays(body)
				for c in check.keys():
					if(c != "Player" and check[c] and get_node("NPCs/" + c).position.distance_to(get_node("NPCs/" + body).position) <= MAX_SEEN_DISTANCE): 
						seen = true
				if(seen): 
					bodies_discovery[body] = true
					# Say that body has been found
					body_discovered(get_node("NPCs/" + body).dead_timer < 10)
		
		if($Player.dragging != null):
			var seen = false
			var check = check_player_rays()
			for c in check.keys():
				if(c != $Player.dragging.name and check[c] and get_node("NPCs/" + c).position.distance_to($Player.position) <= MAX_SEEN_DISTANCE): 
					seen = true
			if(seen):
				set_all_reputations(0, "Player", [])
				# Say that you were seen carrying the body
		$Timers/BodyTimer.start()
	
	if($Timers/DeleteTimer.is_stopped()):
		for del_check in del_checks:
			del_check["i"] -= 1;
			
			if(del_check["i"] == 0): 
				del_checks.erase(del_check)
				del_check["item"].remove()
		$Timers/DeleteTimer.start()
	
	if($Timers/FireTimer.is_stopped()):
		var fires = count_children($World/fires, "Fire")
		check_too_many_fires(fires)
		
		if(fires > 0 and ($NPCs/FireDepartmentMan.override_task == null or $NPCs/FireDepartmentWoman.override_task == null)):
			$NPCs/FireDepartmentMan.handle_override_task({"type": "EXTINGUISH_FIRE", "force_outside": true})
			$NPCs/FireDepartmentWoman.handle_override_task({"type": "EXTINGUISH_FIRE", "force_outside": true})
		elif(fires == 0 and $NPCs/FireDepartmentMan.override_task != null and $NPCs/FireDepartmentWoman.override_task != null and ($NPCs/FireDepartmentMan.override_task.type == "EXTINGUISH_FIRE" or $NPCs/FireDepartmentWoman.override_task.type == "EXTINGUISH_FIRE")):
			$NPCs/FireDepartmentMan.override_task = null
			$NPCs/FireDepartmentMan.fightFire = false
			$NPCs/FireDepartmentWoman.override_task = null
			$NPCs/FireDepartmentWoman.fightFire = false
		$Timers/FireTimer.start()
	
	Check_all_dead()
	check_player_left()

func decrease_all_reputations(amount, subject, exclude):
	for c in $NPCs/Mayor.names.keys():
		if(exclude.has(c)): continue
		get_node("NPCs/" + c).reputation[subject] -= amount

func set_all_reputations(amount, subject, exclude):
	for c in $NPCs/Mayor.names.keys():
		if(exclude.has(c)): continue
		get_node("NPCs/" + c).reputation[subject] = amount

func body_discovered(fresh):
	if fresh:
		set_all_reputations(0, "Player", [])
	else:
		decrease_all_reputations(5, "Player", [])

func check_postman_efficiency():
	var postman = $NPCs/Postman
	if(postman.moves > 0):
		city.post_efficiency = postman.finished_moves / postman.moves
	
	if(city.post_efficiency < .75): set_all_reputations(30, "Postman", ["Postman"])
	if(city.post_efficiency < .50): set_all_reputations(10, "Postman", ["Postman"])
	if(city.post_efficiency < .25): 
		set_all_reputations(0, "Postman", ["Postman"])
		postman.fired = true

func count_children(node, name):
	var count = 0
	
	for child in node.get_children():
		if name in child.name: count += 1
	
	return count

func hour_events(hour):
	match hour:
		7:
			spawn_money_at_bank()
		8:
			if($NPCs/Postman.is_gone() and $NPCs/GeneralStoreman.is_gone()):
				days_disconnected += 1
				
				if(days_disconnected >= 3):
					Global.ending = 7
					get_tree().change_scene("res://Ending.tscn")
	
func spawn_money_at_bank():
	var loc1 = $Buildings/Bank/Location1
	var loc2 = $Buildings/Bank/Location2
	
	if(bank_money[0] == null and city.unplaced_money > 0):
		city.unplaced_money -= 1
		bank_money[0] = $Items.create_item("money", loc1.global_position)
		
	if(bank_money[1] == null and city.unplaced_money > 0):
		city.unplaced_money -= 1
		bank_money[1] = $Items.create_item("money", loc2.global_position)
	
	if(bank_money[0] == null and bank_money[1] == null and city.unplaced_money <= 0):
		city_bankruptcy()

func city_bankruptcy():
	city.bankrupt = true
	decrease_all_reputations(50, "Mayor", [])

func _on_item_pickup(type, item):
	# Money at bank
	print(type)
	if(type.name == "money"):
		var picked_up = false
		
		if(item == bank_money[0]): 
			bank_money[0] = null
			picked_up = true
		elif(item == bank_money[1]): 
			bank_money[1] = null
			picked_up = true
			
		if picked_up:
			rob_checks.push_back({"i": 5, "building": "Bank", "finder_decrease": 20, "global_decrease": 40, "owner_decrease": 50, "owner": "BankWoman"})
			rob_checks.push_back({"i": 15, "building": "Bank", "finder_decrease": 10, "global_decrease": 30, "owner_decrease": 10, "owner": "BankWoman"})

func check_player_rays():
	var names = $NPCs/Mayor.names.keys()
	var results = {}
	
	for name in names:
		var result = get_world_2d().direct_space_state.intersect_ray(get_node("NPCs/" + name).global_position, $Player.global_position, [$Player, get_node("NPCs/" + name)])
		if result: results[name] = false
		else: results[name] = true
		
	return results
	
func check_npc_rays(name):
	var names = $NPCs/Mayor.names.keys()
	names.erase(name)
	var results = {}
	
	for name_ in names:
		var result = get_world_2d().direct_space_state.intersect_ray(get_node("NPCs/" + name_).global_position, get_node("NPCs/" + name).global_position, [get_node("NPCs/" + name_), get_node("NPCs/" + name)])
		if result: results[name_] = false
		else: results[name_] = true
	
	var result = get_world_2d().direct_space_state.intersect_ray($Player.global_position, get_node("NPCs/" + name).global_position, [$Player, get_node("NPCs/" + name)])
	if result: results["Player"] = false
	else: results["Player"] = true
	
	return results

func check_ray(c1, c2):
	var result = get_world_2d().direct_space_state.intersect_ray(c1.global_position, c2.global_position, [c1, c2])
	if result: return false
	
	return true

func seen_attack(by, on):
	var seen = false
	if(by.name == "Player"):
		var check = check_player_rays()
		for c in check.keys():
			if c == on: continue
			if get_node("NPCs/" + c).position.distance_to($Player.position) <= MAX_SEEN_DISTANCE and get_node("NPCs/" + on).reputation["Player"] >= 50:
				seen = true
		if seen:
			set_all_reputations(0, by.name, [])
	else:
		var check = check_npc_rays(by.name)
		for c in check.keys():
			if c == on: continue
			if on == "Player": return
			if get_node("NPCs/" + c).position.distance_to(by.position) <= MAX_SEEN_DISTANCE and get_node("NPCs/" + on).reputation["player"] >= 50:
				seen = true
		if seen:
			set_all_reputations(0, by.name, [by.name])

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_H:
			print(check_player_rays())
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_C:
			$"NPCs/Mayor".reputation['Player'] = 0

func check_too_many_fires(n):
	if(n > MAX_FIRES):
		Global.ending = 4
		get_tree().change_scene("res://Ending.tscn")

func Check_all_dead():
	if(($NPCs/Mayor.dead == true and $NPCs/Postman.dead == true and $NPCs/Sheriff.dead == true and $NPCs/GeneralStoreman.dead == true and $NPCs/BankWoman.dead == true and $NPCs/Doctor.dead == true and $NPCs/FireDepartmentMan.dead == true and $NPCs/FireDepartmentWoman.dead == true and $NPCs/OldJoe.dead == true and $NPCs/SaloonOwner.dead == true) or Input.is_action_pressed("ui_1")):
		Global.ending = 1
		get_tree().change_scene("res://Ending.tscn")
		
func check_player_left():
	if(($Player.position.x >= 6656 or $Player.position.x <= 0 or $Player.position.y >= 4000 or $Player.position.y <= 0) and $Player.in_building == null):
		Global.ending = 2
		get_tree().change_scene("res://Ending.tscn")

var entered_firearea = false

func _on_FireArea2_body_entered(body):
	entered_firearea(body, "FireArea2")

func _on_FireArea1_body_entered(body):
	entered_firearea(body, "FireArea1")
	
func entered_firearea(body, name):
	if(body.name == "Bullet"):
		var fire = FIRE.instance()
		fire.global_position = get_node("World/misc/" + name).global_position
		$World/fires.add_child(fire)
	
	if(body.name != "Player"): return
	
	if(!entered_firearea):
		entered_firearea = true
		$CanvasLayer/Dialog.start_story("fire-start", [], [], self)
	elif($Player.has_item("gun")):
		$CanvasLayer/Dialog.start_story("fire-yes", [], [], self)
	else:
		$CanvasLayer/Dialog.start_story("fire-no", [], [], self)

func _story_message(id, story):
	pass

func _story_exit(id, story):
	if(story == "fire-start" or story == "fire-yes" or story == "fire-no"):
		$Player.interact_lock = false

func _on_FireArea1_area_entered(area):
	entered_firearea(area, "FireArea2")

func _on_FireArea2_area_entered(area):
	entered_firearea(area, "FireArea2")

func _on_AudioStreamPlayer_finished():
	$Timers/MusicTimer.start()

func _on_MusicTimer_timeout():
	$AudioStreamPlayer.play()
