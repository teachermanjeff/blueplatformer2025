extends CharacterBody2D
var movespeed = 50
const gravity = 60
#@export var anim: AnimatedSprite2D
var can_attack = true
var player_chase = false
var speed = 25
var dead = false
var current_dir = "right"  # direction the character is facing
var shoot = true

var knockback = false



var bullet = preload("res://scenes/enemy_bullet.tscn") # Drag & drop Bullet.tscn in the inspector
@onready var gun_muzzle = $gun_muzzle  # Make sure you added a Marker2D called "GunMuzzle"
@onready var player = $"../dantevireo"
func _ready():
	$Sprite2D.play("idle")
	
	pass
	
func _physics_process(delta: float) -> void:

	if player_chase == true and dead == false:
		#velocity.x = movespeed
		if player.global_position.x > global_position.x:
			print("i am working(24)")
			velocity.x = 100
			current_dir = "right"
			print(velocity)
			$Sprite2D.flip_h = false
			$Sprite2D.play("default")
			move_and_slide()
		if player.global_position.x < global_position.x:
			print("i am working(29)")
			current_dir = "left"
			velocity.x = 100
			print(velocity)
			$Sprite2D.flip_h = true
			$Sprite2D.play("default")
			move_and_slide()
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
		if is_on_wall():
			movespeed = -movespeed


func _on_hitbox_body_entered(body: Node2D) -> void:
	if dead == false: 
		if can_attack == true:
			get_parent().get_node("HUD").health -= 1
			can_attack = false

			if current_dir == "right":
				body.position.x += 50
			else:
				body.position.x -= 50

			$attacktimer.start()
	


func _on_hurt_area_entered(area: Area2D) -> void:
	$Sprite2D.play("dead")
	dead = true
	print("you dead")
	velocity.x = 0
	$CollisionShape2D.queue_free()
	$hurt/CollisionShape2D.queue_free()
	$dead.play()
	#area.queue_free()
	#queue_free()

func _on_detectionzone_body_entered(body: Node2D) -> void:
	print("entered")
	if dead == false:
		print("entered2")
		#var player = body
		player_chase = true
		$enemysound.play()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if dead == false:
		shoot = true
	pass # Replace with function body.


func _on_head_area_entered(area: Area2D) -> void:
	player.global_position.x -= 100
	pass # Replace with function body.


func _on_attacktimer_timeout() -> void:
	can_attack = true
	pass # Replace with function body.



	pass # Replace with function body.


func _on_exitdetectionzone_body_exited(body: Node2D) -> void:
	if dead == false:
		player_chase = false
	if player_chase == false :
		if velocity.x > 0:
			velocity.x -= 1
		else:
			velocity.x +=1
	$Sprite2D.play("idle")
	pass # Replace with function body.
