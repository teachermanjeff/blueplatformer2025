extends CharacterBody2D

# Enemy properties
var health = 30
var movespeed = 50
const gravity = 60
# var anim: AnimatedSprite2D — commented out, likely for future animation control
var can_attack = true
var player_chase = false
var speed = 25
var dead = false
var current_dir = "right"  # Tracks which way the enemy is facing
var shoot = true
var knockback = false

# Preload bullet scene for shooting
var bullet = preload("res://scenes/enemy_bullet.tscn")

# Nodes from the scene
@onready var gun_muzzle = $gun_muzzle  # Position where bullets spawn
@onready var player = $"../dantevireo"  # Reference to the player node

func _ready():
	# Play idle animation when the scene starts
	$Sprite2D.play("idle")
	pass

func _physics_process(delta: float) -> void:
	# Enemy AI logic: only run if chasing the player and not dead
	if player_chase == true and dead == false:
		# Move toward the player based on their position
		if player.global_position.x > global_position.x:
			print("i am working(24)")
			velocity.x = 150
			current_dir = "right"
			print(velocity)
			$Sprite2D.flip_h = false  # Face right
			$Sprite2D.play("default")  # Play walking animation
			move_and_slide()

		if player.global_position.x < global_position.x:
			print("i am working(29)")
			current_dir = "left"
			velocity.x = -150
			print(velocity)
			$Sprite2D.flip_h = true  # Face left
			$Sprite2D.play("default")
			move_and_slide()


		# If enemy hits a wall, reverse direction (not used now)
		if is_on_wall():
			movespeed = -movespeed

# When the enemy's hitbox touches the player
func _on_hitbox_body_entered(body: Node2D) -> void:
	if dead == false and can_attack == true:
		# Reduce player's health
		get_parent().get_node("HUD").health -= 1
		can_attack = false

		$attacktimer.start()

# When the enemy is damaged
func _on_hurt_area_entered(area: Area2D) -> void:
	health -= 1
	if health <= 0:
		$Sprite2D.play("dead")
		dead = true
		print("you dead")
		velocity.x = 0
		$CollisionShape2D.queue_free()
		$hurt/CollisionShape2D.queue_free()
		$hurt2.play()
	# area.queue_free() — optional if you want the projectile to disappear
	# queue_free() — remove the enemy entirely

# Player enters the detection zone
func _on_detectionzone_body_entered(body: Node2D) -> void:
	print("entered")
	if dead == false:
		print("entered2")
		player_chase = true
		$enemysound.play()

# Timer event: reset shooting ability
func _on_timer_timeout() -> void:
	if dead == false:
		shoot = true

# Timer event: reset attack ability
func _on_attacktimer_timeout() -> void:
	can_attack = true

# Player exits the detection zone
func _on_exitdetectionzone_body_exited(body: Node2D) -> void:
	if dead == false:
		player_chase = false
	if player_chase == false:
		# Gradually stop moving when player is out of range
		if velocity.x > 0:
			velocity.x -= 1
		else:
			velocity.x += 1
		$Sprite2D.play("idle")
