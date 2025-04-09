extends CharacterBody2D
var movespeed = 100
const gravity = 60
var health = 3


func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	velocity.x = movespeed
	move_and_slide()
	
