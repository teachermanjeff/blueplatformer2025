extends CharacterBody2D

const MOVE_SPEED = 100  # Increased for better movement
const GRAVITY = 9.8  # More realistic gravity

func _physics_process(delta):
	# Apply gravity every frame
	velocity.y += GRAVITY 

	# Handle horizontal movement
	if Input.is_action_pressed("move_left"):
		velocity.x = -MOVE_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = MOVE_SPEED
	else:
		velocity.x = 0  # Stop horizontal movement if no input
	
	# Move the character
	move_and_slide()
