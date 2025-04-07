extends CharacterBody2D

var player = null
var shooting_range = 300 # Distance for shooting
var shoot_delay = 1.0 # Time delay between shots
var shoot_timer = 0.0
var bullet_scene: PackedScene 
var gun_marker: Node2D # Reference to the gun marker

# Called when the enemy is ready
func _ready():
	# Get the gun marker node
	var gun_marker: Marker2D # Replace with the actual path to the gun marker node
	if gun_marker == null:
		print("Gun marker not found!")

# Called every frame
func _process(delta):
	if player != null:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player <= shooting_range:
			look_at(player.global_position)  # Rotate to face player
			
			shoot_timer -= delta
			if shoot_timer <= 0:
				shoot_timer = shoot_delay
				shoot_at_player()

# Shoot function
func shoot_at_player():
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	
	# Set the bullet's position to the gun marker's position
	bullet.global_position = gun_marker.global_position
	
	# Get the direction from the gun marker to the player
	var direction = (player.global_position - gun_marker.global_position).normalized()
	bullet.set_velocity(direction)

# Detect player when they enter the enemy's detection range (can use Area2D for detection)
func _on_Player_entered_area(player_object):
	if player_object.is_in_group("player"):
		player = player_object
