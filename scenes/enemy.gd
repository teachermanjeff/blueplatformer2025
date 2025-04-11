extends CharacterBody2D

# Variables for movement, health, etc.
var speed = 100
var health = 3
var direction = 1  # 1 for right, -1 for left

# References to components
@onready var sprite = $Sprite

func _ready():
	# Set initial direction (can flip sprite depending on direction)
	flip_sprite()

func _process(delta):
	# Create a velocity vector to control movement
	var velocity = Vector2(speed * direction, 0)
	
	# Move the enemy horizontally using move_and_slide with just the velocity
	move_and_slide(velocity)

	# Flip direction if hitting a wall or edge of platform
	if is_on_wall():
		direction = -direction
		flip_sprite()

# Function to flip the sprite when the enemy changes direction
func flip_sprite():
	sprite.flip_h = direction == -1

# Function to handle damage when the enemy collides with a projectile or player
func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

# Function to handle enemy death
func die():
	queue_free()  # Remove the enemy from the scene
