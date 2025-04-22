extends Area2D

@export var speed = 500
var direction = 1

func _process(delta):
	position.x += direction * speed * delta
