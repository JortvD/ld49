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

func get_random_spot():
	var x = round(($BR.global_position.x - $TL.global_position.x) * randf()) + $TL.global_position.x
	var y = round(($BR.global_position.y - $TL.global_position.y) * randf()) + $TL.global_position.y
	
	return Vector2(x, y)

func get_entrance_position():
	return $Entrance/CollisionShape2D.global_position

func get_exit_position():
	return $Exit/CollisionShape2D.global_position

func _on_entrance_entered(body):
	if (body.name == "Player"):
		entering = true
		body.in_building = name
		$"/root/MainScene/CanvasLayer/Blacken".effect(effect_duration)
		$Timer.wait_time = effect_duration
		$Timer.start()
	
	if ("NPC" in body.get_parent().name):
		body.path = PoolVector2Array()
		body.position = $ExitLocation.global_position
		body.in_building = name
		
func _on_exit_entered(body):
	if (body.name == "Player"):
		entering = false
		$"/root/MainScene/CanvasLayer/Blacken".effect(effect_duration)
		$Timer.wait_time = effect_duration
		$Timer.start()
	
	if ("NPC" in body.get_parent().name):
		body.path = PoolVector2Array()
		body.position = $EntranceLocation.global_position
		body.in_building = null

func _on_Timer_timeout():
	if(!moving_camera):
		camera_speed = get_node("../../Player/Camera2D").get_follow_smoothing()
		if entering:
			get_node("../../Player").position = $ExitLocation.global_position
			entering = false
		else:
			get_node("../../Player").position = $EntranceLocation.global_position
			get_node("../../Player").in_building = null
			
		get_node("../../Player/Camera2D").set_follow_smoothing(20)
		moving_camera = true
	else:
		get_node("../../Player/Camera2D").set_follow_smoothing(camera_speed)
		moving_camera = false
		$Timer.stop()
