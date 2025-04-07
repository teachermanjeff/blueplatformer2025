extends CharacterBody2D

const MOVE_SPEED = 100
const GRAVITY = 980
const JUMP_SPEED = -600

var current_dir = "right"  # direction the character is facing

@export var BulletScene: PackedScene  # Bullet scene for shooting
@onready var gun_muzzle = $GunMuzzle  # Reference to the GunMuzzle marker
@export var ammo_label: Label    # Ammo label reference
@export var player: NodePath  # Expose player node path for referencing

var shots_left := 10
const MAX_SHOTS := 10
const RELOAD_TIME := 5.0
var reloading := false

var player_node: CharacterBody2D  # To store the player reference

func _ready():
	# Get the player node by path
	if player != null:
		player_node = get_node(player)  # Use the NodePath to get the player
	update_ammo_label()

func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Move towards the player
	move_towards_player()

	# Handle shooting
	if Input.is_action_just_pressed("shoot"):
		shoot()

	# Handle reloading (press "R")
	if Input.is_action_just_pressed("reload"):
		if !reloading and shots_left < MAX_SHOTS:
			start_reload()

	# Play animation based on movement and direction
	play_anim()

	# Move the enemy using move_and_slide
	move_and_slide()

# Function to move the enemy towards the player
func move_towards_player():
	if player_node:
		var direction = (player_node.global_position - global_position).normalized()
		velocity.x = direction.x * MOVE_SPEED
		velocity.y = direction.y * MOVE_SPEED

		# Flip direction based on movement
		if direction.x < 0:
			current_dir = "left"
		else:
			current_dir = "right"

# Function to play the correct animation
func play_anim():
	var anim = $AnimatedSprite2D

	if reloading:
		anim.play("reload")  # Play the reload animation
	elif current_dir == "right":
		anim.flip_h = false
		anim.play("walk")  # Play the walk animation
	elif current_dir == "left":
		anim.flip_h = true
		anim.play("walk")  # Play the walk animation

# Function to shoot bullets like the player does
func shoot():
	if reloading or shots_left <= 0:
		return

	# Create a bullet instance
	var bullet = BulletScene.instantiate()
	bullet.global_position = gun_muzzle.global_position

	if current_dir == "right":
		bullet.direction = Vector2.RIGHT
	else:
		bullet.direction = Vector2.LEFT

	get_tree().current_scene.add_child(bullet)

	# Decrease the number of shots
	shots_left -= 1
	update_ammo_label()

	if shots_left == 0:
		start_reload()

# Start the reloading process
func start_reload():
	reloading = true
	ammo_label.text = "Reloading..."
	$AnimatedSprite2D.play("reload")

	# Wait for reload to finish (use a timer)
	await get_tree().create_timer(RELOAD_TIME).timeout

	shots_left = MAX_SHOTS
	reloading = false
	ammo_label.text = "Ammo: " + str(shots_left) + "/" + str(MAX_SHOTS)

# Function to update the ammo count on the label
func update_ammo_label():
	ammo_label.text = "Ammo: " + str(shots_left) + "/" + str(MAX_SHOTS)
