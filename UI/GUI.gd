extends Control



func update():
	var inventory = $"/root/MainScene/Player".inventory
	
	for i in range($"/root/MainScene/Player".INVENTORY_SIZE):
		var item = inventory[i]
		var node = get_node("Panel" + str(i+1) + "/Sprite" + str(i+1))
		
		if(item == null): 
			node.visible = false
			continue
		
		node.visible = true
		node.texture = load(item.img)
		
func _process(delta):
	$Label.text =  str($"/root/MainScene/CanvasLayer/DayNightCycle".hour) if ($"/root/MainScene/CanvasLayer/DayNightCycle".hour != null) else 6
	$Label2.text = str($"/root/MainScene/CanvasLayer/DayNightCycle".minutes) if ($"/root/MainScene/CanvasLayer/DayNightCycle".minutes != null) else 0

func set_health(value, maximum):
	$HealthBar/TextureProgress.max_value = maximum
	$HealthBar/TextureProgress.value = value
	

