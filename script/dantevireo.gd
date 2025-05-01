extends CharacterBody2D

const MOVE_SPEED = 100
const GRAVITY = 2200
const JUMP_SPEED = -600
const RUN_SPEED = 200  # Speed when running (Shift pressed)

var knockback = false
var current_dir = "right"  # direction the character is facing
var BulletScene = preload("res://bullet.tscn")
@onready var gun_muzzle = $GunMuzzle  # Make sure you added a Marker2D called "GunMuzzle"
@export var ammo_label: Label    # Reference to the Label node inside CanvasLayer
var can_shoot = true
var shots_left = 9
const MAX_SHOTS := 10
const RELOAD_TIME := 2.5
var reloading := false

func _physics_process(delta):

	# Apply gravity
	velocity.y += GRAVITY * delta
	if knockback == true:
		if get_parent().get_node("enemyscreen").player.global_position.x > global_position.x:
			$AnimatedSprite2D.global_position.x += 50
			knockback = false
		if get_parent().get_node("enemyscreen").player.global_position.x < global_position.x:
			$AnimatedSprite2D.global_position.x -= 50
			knockback = false
	
	# Handle shooting
	


	var movement = 0  # 0 = idle, 1 = moving

	# Prevent movement if reloading
	if reloading:
		velocity.x = 0
		movement = 0
	else:
		# Handle horizontal movement
		if Input.is_action_pressed("move_left"):
			current_dir = "left"
			velocity.x = -MOVE_SPEED if !Input.is_action_pressed("shift") else -RUN_SPEED
			movement = 1
		elif Input.is_action_pressed("move_right") && Input.is_action_pressed("move_right"):
			current_dir = "right"
			velocity.x = RUN_SPEED if Input.is_action_pressed("shift") else MOVE_SPEED
			movement = 1
		else:
			velocity.x = 0

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor() and !reloading:
		velocity.y = JUMP_SPEED

	# Handle shooting
	if Input.is_action_just_pressed("shoot") and !reloading and is_on_floor():
			shoot()
	# Check if the player presses "R" to reload
	if Input.is_action_just_pressed("reload") and !reloading and shots_left < 10:
		start_reload()

	# Play animation based on movement, direction, and shift key
	play_anim(movement)

	# Move the character
	move_and_slide()

func play_anim(movement):
	var anim = $AnimatedSprite2D

	# Flip based on direction
	if current_dir == "right":
		anim.flip_h = false
	elif current_dir == "left":
		anim.flip_h = true

	# Play appropriate animation
	if reloading:
		anim.play("reload")
	elif !is_on_floor():
		anim.play("jump")
	elif Input.is_action_pressed("shift") and movement == 1:  # Ensure running only if moving
		anim.play("run")
	elif movement == 1:
		anim.play("walk")
	else:
		anim.play("idle1")


func shoot():
	if can_shoot == true:
		can_shoot = false
		$Timer.start()
		if reloading or shots_left <= 0:
			return


		# SHOOT
		var bullet = BulletScene.instantiate()
		bullet.global_position = gun_muzzle.global_position
		$AnimatedSprite2D.play("shot")


		if current_dir == "right":
			bullet.direction = 1
		else:
			bullet.direction = -1

		get_tree().current_scene.add_child(bullet)

		# Reduce shots left
		get_parent().get_node("HUD").ammo -= 1

		# Start reload if out of ammo
		if get_parent().get_node("HUD").ammo == 0:
			start_reload()


func start_reload():
	reloading = true
	print("Reloading...")

	# Set the ammo label to "Reloading" while reloading
	get_parent().get_node("HUD").ammo_reload = true

	# Start the reload animation here
	$AnimatedSprite2D.play("reload")

	# Wait for the reload to finish (this could be done with a timer or async)
	await get_tree().create_timer(RELOAD_TIME).timeout
	get_parent().get_node("HUD").ammo = 10
	reloading = false
	get_parent().get_node("HUD").ammo_reload = false
	print("Reload complete!")

	# After reloading, return to idle or walk animation
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle1")
	else:
		$AnimatedSprite2D.play("walk")

# Function to update the ammo counter on screen
func update_ammo_label():
	ammo_label.text = "Ammo: " + str(shots_left) + "/" + str(MAX_SHOTS)

func _on_hurtzone_area_entered(area: Area2D) -> void:
	print("i am shot")
	get_parent().get_node("HUD").health -= 1
	knockback = true
	pass # Replace with function body.

  # Check if health is 0 and restart the scene (or handle death)
	if get_parent().get_node("HUD").health == 0:
		$AnimatedSprite2D.play("death")  # Reload the scene to restart


func _on_timer_timeout() -> void:
	can_shoot = true
	pass # Replace with function body.
