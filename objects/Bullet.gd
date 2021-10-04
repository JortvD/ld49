extends Area2D

var speed = 750
var damage = 10
var creator = null

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	var node = null
	
	if (body.name == "Mayor"):
		node = get_node("/root/MainScene/NPCs/Mayor")
	if (body.name == "Postman"):
		node = get_node("/root/MainScene/NPCs/Postman")
	if (body.name == "Sheriff"):
		node = get_node("/root/MainScene/NPCs/Sheriff")
	if (body.name == "GeneralStoreman"):
		node = get_node("/root/MainScene/NPCs/GeneralStoreman")
	if (body.name == "BankWoman"):
		node = get_node("/root/MainScene/NPCs/BankWoman")
	if (body.name == "Doctor"):
		node = get_node("/root/MainScene/NPCs/Doctor")
	if (body.name == "FireDepartmentMan"):
		node = get_node("/root/MainScene/NPCs/FireDepartmentMan")
	if (body.name == "FireDepartmentWoman"):
		node = get_node("/root/MainScene/NPCs/FireDepartmentWoman")
	if (body.name == "OldJoe"):
		node = get_node("/root/MainScene/NPCs/OldJoe")
	if (body.name == "SaloonOwner"):
		node = get_node("/root/MainScene/NPCs/SaloonOwner")
	if (body.name == "Player"):
		node = get_node("/root/MainScene/Player")
	
	if(node != null):
		node.health -= damage
		
		if(node.name != "Player"):
			node.reputation[creator] = 0
			var creater_node = $"/root/MainScene/Player" if creator == "Player" else get_node("/root/MainScene/NPCs/" + creator)
			$"/root/MainScene".seen_attack(creater_node, node.name)
			
			if(node.health <= 0):
				node.killed_by = creater_node
	
	queue_free()
