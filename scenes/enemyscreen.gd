extends CharacterBody2D
var movespeed = 50
const gravity = 60
@export var anim: AnimatedSprite2D


func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	velocity.x = movespeed
	$Sprite2D.play("default")
	move_and_slide()


	if is_on_wall():
		movespeed = -movespeed
		
		
	if movespeed > 0:
		$Sprite2D.flip_h = false
	else: 
		$Sprite2D.flip_h = true
	
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	get_parent().get_node("HUD").health -= 1
	get_parent().get_node("player").position.x -= 50
	


func _on_hurt_area_entered(area: Area2D) -> void:
	area.queue_free()
	queue_free()
	pass # Replace with function body.
