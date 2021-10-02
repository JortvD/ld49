extends Node2D

export(Texture) var texture
export(Vector2) var entrance_location
export(Vector2) var entrance_shape

func _ready():
	$Sprite.texture = texture
	var size = texture.get_size() / 2
	$StaticBody2D/CollisionShape2D.shape.extents = size
	$Area2D.position = entrance_location
	$Area2D/CollisionShape2D.shape.extents = entrance_shape


func _on_Area2D_body_entered(body):
	if (body.name == "Player"):
		get_node("../../Player").position = Vector2(-600,-600)
	if (body.name == "NPC"):
		get_node("../../NPC").position = Vector2(256,192)
