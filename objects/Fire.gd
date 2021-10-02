extends Node2D

func _on_CollisionShape2D_body_entered(body):
	if (body.name == "Player"):
		get_node("../../Player").health -= 10
		print(get_node("../../Player").health)
