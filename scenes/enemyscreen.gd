extends CharacterBody2D
var movespeed = 50
const gravity = 60
#@export var anim: AnimatedSprite2D
var player = null
var player_chase = false
var speed = 25
var dead = false
var current_dir = "right"  # direction the character is facing
var shoot = true
var bullet = preload("res://enemy_bullet.tscn") # Drag & drop Bullet.tscn in the inspector
@onready var gun_muzzle = $gun_muzzle  # Make sure you added a Marker2D called "GunMuzzle"

func _ready():
	pass
	
func _physics_process(delta: float) -> void:

	if player_chase:
		#velocity.x = movespeed
		if player.position.x > position.x:
			velocity.x += 2
		if player.position.x < position.x:
			velocity.x -= 2
			
		#var Bullet = bullet.instantiate()
		if shoot == true:
			var new_bullet = bullet.instantiate()
			new_bullet.global_position = gun_muzzle.global_position
			get_parent().add_child(new_bullet)
			if current_dir == "right":
				new_bullet.direction = 1
			else:
				new_bullet.direction = -1
			shoot = false
			$Timer.start()


		#get_tree().current_scene.add_child(bullet)
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
		body.position.x -= 50
	


func _on_hurt_area_entered(area: Area2D) -> void:
	$Sprite2D.play("dead")
	var dead = true
	print("you dead")
	area.queue_free()
	queue_free()
	


func _on_detectionzone_body_entered(body: Node2D) -> void:
	print("entered")
	if dead == false:
		print("entered2")
		player = body
		player_chase = true
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	shoot = true
	pass # Replace with function body.
