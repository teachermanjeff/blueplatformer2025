extends CharacterBody2D

const MOVE_SPEED = 100
const GRAVITY = 980  # 9.8 is too low; Godot uses pixels, so 980 is more realistic
const JUMP_SPEED = -600

func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Handle horizontal movement
	if Input.is_action_pressed("move_left"):
		velocity.x = -MOVE_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = MOVE_SPEED
	else:
		velocity.x = 0  # Stop movement

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_SPEED

	# Move the character
	move_and_slide()
