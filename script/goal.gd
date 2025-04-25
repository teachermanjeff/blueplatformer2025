extends Area2D

@export_file var nextlevel

func _on_body_entered(body: CharacterBody2D) -> void:
	get_tree().change_scene_to_file(nextlevel)
	pass # Replace with function body.
