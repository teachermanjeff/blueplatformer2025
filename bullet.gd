extends Area2D

@export var speed = 500
var direction = 1

func _process(delta):
	position.x += direction * speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	pass # Replace with function body.
