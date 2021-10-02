extends Control

func _process(delta):
	$Panel/Sprite.texture = load($"/root/MainScene/Player".inventory[0].img)
	$Panel/Sprite.texture = load($"/root/MainScene/Player".inventory[1].img)
	$Panel/Sprite.texture = load($"/root/MainScene/Player".inventory[2].img)
	$Panel/Sprite.texture = load($"/root/MainScene/Player".inventory[3].img)
	$Panel/Sprite.texture = load($"/root/MainScene/Player".inventory[4].img)
	
