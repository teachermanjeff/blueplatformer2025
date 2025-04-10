extends CharacterBody2D
var movespeed = 50
const gravity = 60



func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	velocity.x = movespeed
	move_and_slide()
	
	if is_on_wall():
		movespeed = -movespeed
		
		
	if movespeed > 0:
		$Sprite2D.flip_h = false
	else: 
		$Sprite2D.flip_h = true
	
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	get_tree().get_node()
	health = health - 1
pass # Replace with function body.
