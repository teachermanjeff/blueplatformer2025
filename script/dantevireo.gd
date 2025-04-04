extends CharacterBody2D

const MOVE_SPEED = 100
const GRAVITY = 980  # 9.8 is too low; Godot uses pixels, so 980 is more realistic
const JUMP_SPEED = -600

var current_dir = "right" #setsdirection in which Character wants to face


func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Handle horizontal movement
	if Input.is_action_pressed("move_left"):
		play_anim(1)
		current_dir = "left"
		velocity.x = -MOVE_SPEED
	elif Input.is_action_pressed("move_right"):
		play_anim(1)
		current_dir = "right"
		velocity.x = MOVE_SPEED
	else:
		play_anim(0)
		velocity.x = 0  # Stop movement

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_SPEED

	# Move the character
	move_and_slide()
	
	func play_anim(direction):
		var dir = current_dir
		var anim = $AnimatedSprite2D
		
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("walk")
			elif movement == 0:
				anim.play("idle1")
				
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("walk")
			elif movement == 0:
				anim.play("idle1")
