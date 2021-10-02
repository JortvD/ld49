extends Node2D

export(Texture) var texture
export(Vector2) var entrance_location
export(Vector2) var entrance_shape

var moving_camera = false
var camera_speed = 0

func _ready():
	$Sprite.texture = texture
	var size = texture.get_size() / 2
	$StaticBody2D/CollisionShape2D.shape.extents = size
	$Area2D.position = entrance_location
	$Area2D/CollisionShape2D.shape.extents = entrance_shape
	

func _on_Area2D_body_entered(body):
	if (body.name == "Player"):
		var effect_duration = .25
		$"/root/MainScene/CanvasLayer/Blacken".effect(effect_duration)
		$Timer.wait_time = effect_duration
		$Timer.start()
		
	if (body.name == "NPC"):
		get_node("../../NPC").position = Vector2(200,192)


func _on_Timer_timeout():
	if(!moving_camera):
		camera_speed = get_node("../../Player/Camera2D").get_follow_smoothing()
		get_node("../../Player").position = Vector2(-5000,-5000)
		get_node("../../Player/Camera2D").set_follow_smoothing(20)
		moving_camera = true
	else:
		get_node("../../Player/Camera2D").set_follow_smoothing(camera_speed)
		moving_camera = false
		$Timer.stop()
