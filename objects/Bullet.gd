extends Area2D

var speed = 750
var damage = 10

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if (body.name == "NPC"):
		get_node("../NPC").health -= damage
	if (body.name == "Player"):
		get_node("../Player").health -= damage
	
	queue_free()
