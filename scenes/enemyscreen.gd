extends CharacterBody2D
var movespeed = 50
const gravity = 60
@export var anim: AnimatedSprite2D
var player = null
var player_chase = false
var speed = 25
var dead = false

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	if player_chase == true:
			#velocity.x = moves dpeed
		if player.position.x > position.x:
			velocity.x += 5
		if player.position.x < position.x:
			velocity.x -= 5
	
	$Sprite2D.play("default")
	move_and_slide()


	if is_on_wall():
		movespeed = -movespeed
		
		
	if movespeed > 0:
		$Sprite2D.flip_h = false
	else: 
		$Sprite2D.flip_h = true
	
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	if dead == false: 
		get_parent().get_node("HUD").health -= 1
		get_parent().get_node("player").position.x -= 50
	


func _on_hurt_area_entered(area: Area2D) -> void:
	$Sprite2D.play("dead")
	dead = true
	
	#area.queue_free()
	#queue_free()
	pass # Replace with function body.


func _on_detectionzone_body_entered(body: Node2D) -> void:
	if dead == false:
		player = body
		player_chase = true
	pass # Replace with function body.
