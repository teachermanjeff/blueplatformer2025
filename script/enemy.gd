extends CharacterBody2D
const gravity = 60
var health = 3

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	move_and_slide()


	


func _on_dmgarea_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
