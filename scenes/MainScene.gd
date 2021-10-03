extends Node2D

var city = {
	"unplaced_money": 4,
	"bankrupt": false
}

var bank_money = [null, null]
var last_hour = -1
var rob_checks = []
var del_checks = []

func _process(delta):
	if($CanvasLayer/DayNightCycle.hour != last_hour):
		last_hour = $CanvasLayer/DayNightCycle.hour
		hour_events(last_hour)
		
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
	
	if($Timers/DeleteTimer.is_stopped()):
		for del_check in del_checks:
			del_check["i"] -= 1;
			
			if(del_check["i"] == 0): 
				del_checks.erase(del_check)
				del_check["item"].remove()
		$Timers/DeleteTimer.start()

func decrease_all_reputations(amount, subject, exclude):
	for player in $NPCs/Mayor.names.keys():
		if(exclude.has(player)): continue
		get_node("NPCs/" + player).reputation[subject] -= amount

func hour_events(hour):
	match hour:
		7:
			spawn_money_at_bank()
			
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

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_H:
			print(check_player_rays())
