extends Node2D

export(Texture) var texture
export(Vector2) var entrance_location
export(Vector2) var entrance_shape

var moving_camera = false
var camera_speed = 0
var effect_duration = .25
var entering = false

func _ready():
	$Sprite.texture = texture
	var size = texture.get_size() / 2
	$StaticBody2D/CollisionShape2D.shape.extents = size
	
	if($Entrance != null): $Entrance.connect("body_entered", self, "_on_entrance_entered")
	if($Exit != null): $Exit.connect("body_entered", self, "_on_exit_entered")

func _on_entrance_entered(body):
	if (body.name == "Player"):
		entering = true
		$"/root/MainScene/CanvasLayer/Blacken".effect(effect_duration)
		$Timer.wait_time = effect_duration
		$Timer.start()
		
	#if (body.name == "NPC"):
	#	get_node("../../NPC").position = $ExitLocation.global_position
		
func _on_exit_entered(body):
	if (body.name == "Player"):
		entering = false
		$"/root/MainScene/CanvasLayer/Blacken".effect(effect_duration)
		$Timer.wait_time = effect_duration
		$Timer.start()
		
	#if (body.name == "NPC"):
	#	get_node("../../NPC").position = $EntranceLocation.global_position

func _on_Timer_timeout():
	if(!moving_camera):
		camera_speed = get_node("../../Player/Camera2D").get_follow_smoothing()
		if entering:
			get_node("../../Player").position = $ExitLocation.global_position
			entering = false
		else:
			get_node("../../Player").position = $EntranceLocation.global_position
		get_node("../../Player/Camera2D").set_follow_smoothing(20)
		moving_camera = true
	else:
		get_node("../../Player/Camera2D").set_follow_smoothing(camera_speed)
		moving_camera = false
		$Timer.stop()
