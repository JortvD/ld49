extends Node2D

var city = {
	"money": 4
}

var last_hour = -1

func _process(delta):
	if($CanvasLayer/DayNightCycle.hour != last_hour):
		last_hour = $CanvasLayer/DayNightCycle.hour
		hour_events(last_hour)

func hour_events(hour):
	match hour:
		7:
			spawn_money_at_bank()
			
func spawn_money_at_bank():
	var loc1 = $Buildings/Bank/Location1

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
