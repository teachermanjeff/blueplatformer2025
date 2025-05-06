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
var knockback = true

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
			velocity.x = velocity.x + 2
			current_dir = "right"
			print(velocity)
			$Sprite2D.flip_h = false  # Face right
			$Sprite2D.play("default")  # Play walking animation
			move_and_slide()

		if player.global_position.x < global_position.x:
			print("i am working(29)")
			current_dir = "left"
			velocity.x = velocity.x - 2
			print(velocity)
			$Sprite2D.flip_h = true  # Face left
			$Sprite2D.play("default")
			move_and_slide()

		# Uncomment below to enable shooting
		# if shoot == true:
		#     var new_bullet = bullet.instantiate()
		#     new_bullet.global_position = gun_muzzle.global_position
		#     get_parent().add_child(new_bullet)
		#     new_bullet.direction = 1 if current_dir == "right" else -1
		#     shoot = false
		#     $Timer.start()

		# If enemy hits a wall, reverse direction (not used now)
		if is_on_wall():
			movespeed = -movespeed

# When the enemy's hitbox touches the player
func _on_hitbox_body_entered(body: Node2D) -> void:
	if dead == false and can_attack == true:
		# Reduce player's health
		get_parent().get_node("HUD").health -= 1
		can_attack = false

		# Apply knockback to the player
		if current_dir == "right":
			body.position.x += 50
		else:
			body.position.x -= 50

		# Start knockback cooldown and attack cooldown
		$knockback.start()
		knockback = false
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

# Timer event: reset knockback ability
func _on_knockback_timeout() -> void:
	knockback = true

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

# Handles additional knockback when touching a specific area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if knockback == true and dead == false:
		if current_dir == "right":
			body.position.y += 50
			body.position.x += 50
			get_parent().get_node("HUD").health -= 1
			knockback = false
		else:
			body.position.y -= 50
			body.position.x -= 50
			get_parent().get_node("HUD").health -= 1
			knockback = false
		$knockback.start()
