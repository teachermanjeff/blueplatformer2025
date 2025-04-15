extends CharacterBody2D

const MOVE_SPEED = 100
const GRAVITY = 980
const JUMP_SPEED = -400

var current_dir = "right"  # direction the character is facing

@export var BulletScene: PackedScene  # Drag & drop Bullet.tscn in the inspector
@onready var gun_muzzle = $GunMuzzle  # Make sure you added a Marker2D called "GunMuzzle"
@export var ammo_label: Label    # Reference to the Label node inside CanvasLayer

var shots_left := 10
const MAX_SHOTS := 10
const RELOAD_TIME := 2.5
var reloading := false

func _ready():
	# Update the label with the initial ammo count
	update_ammo_label()

func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta

	var movement = 0  # 0 = idle, 1 = moving

	# Prevent movement if reloading
	if reloading:
		velocity.x = 0
		movement = 0
	else:
		# Handle horizontal movement
		if Input.is_action_pressed("move_left"):
			current_dir = "left"
			velocity.x = -MOVE_SPEED
			movement = 1
		elif Input.is_action_pressed("move_right"):
			current_dir = "right"
			velocity.x = MOVE_SPEED
			movement = 1
		else:
			velocity.x = 0

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor() and !reloading:
		velocity.y = JUMP_SPEED

	# Handle shooting
	if Input.is_action_just_pressed("shoot") and !reloading:
		shoot()

	# Check if the player presses "R" to reload
	if Input.is_action_just_pressed("reload") and !reloading and shots_left < MAX_SHOTS:
		start_reload()

	# Play animation based on movement and direction
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
		anim.play("jump")  # <- make sure you have a 'jump' animation
	elif movement == 1:
		anim.play("walk")
	else:
		anim.play("idle1")


func shoot():
	if reloading or shots_left <= 0:
		return

	# SHOOT
	var bullet = BulletScene.instantiate()
	bullet.global_position = gun_muzzle.global_position

	if current_dir == "right":
		bullet.direction = Vector2.RIGHT
	else:
		bullet.direction = Vector2.LEFT

	get_tree().current_scene.add_child(bullet)

	# Reduce shots left
	shots_left -= 1

	# Update ammo label
	update_ammo_label()

	# Start reload if out of ammo
	if shots_left == 0:
		start_reload()

func start_reload():
	reloading = true
	print("Reloading...")

	# Set the ammo label to "Reloading" while reloading
	ammo_label.text = "Reloading..."

	# Start the reload animation here
	$AnimatedSprite2D.play("reload")

	# Wait for the reload to finish (this could be done with a timer or async)
	await get_tree().create_timer(RELOAD_TIME).timeout
	
	shots_left = MAX_SHOTS
	reloading = false
	print("Reload complete!")

	# Update ammo label to reflect the remaining ammo after reloading
	update_ammo_label()

	# After reloading, return to idle or walk animation
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle1")
	else:
		$AnimatedSprite2D.play("walk")

# Function to update the ammo counter on screen
func update_ammo_label():
	ammo_label.text = "Ammo: " + str(shots_left) + "/" + str(MAX_SHOTS)
