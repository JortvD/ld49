extends Area2D

var speed = 750
var damage = 10

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if (body.name == "Mayor"):
		get_node("../NPCs/Mayor").health -= damage
	if (body.name == "Postman"):
		get_node("../NPCs/Mayor").health -= damage
	if (body.name == "Sheriff"):
		get_node("../NPC/Sheriff").health -= damage
	if (body.name == "GeneralStoreman"):
		get_node("../NPC/GeneralStoreman").health -= damage
	if (body.name == "BankWoman"):
		get_node("../NPC/BankWoman").health -= damage
	if (body.name == "Doctor"):
		get_node("../NPC/Doctor").health -= damage
	if (body.name == "FireDepartmentMan"):
		get_node("../NPC/FireDepartmentMan").health -= damage
	if (body.name == "FireDepartmentWoman"):
		get_node("../NPC/FireDepartmentWoman").health -= damage
	if (body.name == "OldJoe"):
		get_node("../NPC/OldJoe").health -= damage
	if (body.name == "SaloonOwner"):
		get_node("../NPC/SaloonOwner").health -= damage
	if (body.name == "Player"):
		get_node("../Player").health -= damage
	
	queue_free()
