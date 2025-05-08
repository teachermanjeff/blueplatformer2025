extends Area2D

func _ready():
	$AnimatedSprite2D.play("idle")
	pass
	
func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
	pass # Replace with function body.
