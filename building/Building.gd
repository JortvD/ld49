extends Node2D

export(Texture) var texture

func _ready():
	$Sprite.texture = texture
	var size = texture.get_size() / 2
	$StaticBody2D/CollisionShape2D.shape.extents = size
