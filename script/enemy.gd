extends CharacterBody2D
const gravity = 60
var health = 3

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	move_and_slide()


	
