extends Node2D

@export var bullet_scene: PackedScene  # Drag your Bullet.tscn here
@export var shoot_interval = 2.0

func _ready():
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.start()

func _on_ShootTimer_timeout():
	var bullet = bullet_scene.instantiate()  # Instantiate the bullet
	print("Bullet instantiated!")  # Debug check

	var muzzle = $Muzzle  # The Marker2D where bullets spawn
	bullet.position = muzzle.global_position  # Position the bullet at the muzzle

	# Set the direction based on the muzzle's rotation
	var direction = muzzle.transform.x.normalized()  # Get the direction the muzzle is facing
	print("Bullet direction:", direction)  # Debug check
	bullet.direction = direction  # Pass the direction to the bullet

	get_tree().current_scene.add_child(bullet)  # Add the bullet to the scene
