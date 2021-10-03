extends Node

onready var ITEM = preload("res://items/Item.tscn")

var types = [
	{"name": "gun", "img": "res://icon.png", "action": "SHOOT", "options": {"rps": 5, "img": "res://icon.png", "speed": 100, "damage": 10}},
	{"name": "money", "img": "res://icon.png", "action": "NONE", "options": {}}
]

func create_item_for_player(name, transform, player, weight):
	var type = get_type(name)
	
	if(type == null): return
	
	var texture = load(type.img)
	var item = ITEM.instance()
	owner.add_child(item)
	item.transform = transform
	item.get_node("Sprite").texture = texture
	item.type = type
	item.linear_velocity = player.position.direction_to(item.position) * weight
	item.angular_velocity = 10
	
	return item

func create_item(name, position):
	var type
	for i in types:
		if(i["name"] == name):
			type = i
			break
			
	if(type == null): return
	
	var texture = load(type.img)
	var item = ITEM.instance()
	owner.add_child(item)
	item.get_node("Sprite").texture = texture
	item.type = type
	item.global_position = position
	
	return item

func get_type(name):
	for i in types:
		if(i["name"] == name):
			return i
	return null
