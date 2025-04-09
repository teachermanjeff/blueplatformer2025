extends CharacterBody2D
var movespeed = 100
const gravity = 60
var health = 3

func _physics_process(delta: float) -> void:
	velocity = movespeed
	move_and_slide()

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	move_and_slide()
