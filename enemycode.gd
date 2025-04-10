extends CharacterBody2D

@export var player: Node2D
@export var shoot_range: float = 300.0
@export var shoot_delay: float = 1.0
@export var gun_marker: Marker2D
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")
@export var timer: Timer

var is_player_nearby = false

func _ready():
	timer.wait_time = shoot_delay
	timer.start()

func _process(delta):
	if is_player_nearby:
		aim_at_player()
		if timer.time_left == 0:
			shoot()

func _on_Timer_timeout():
	if player:
		var distance = global_position.distance_to(player.global_position)
		print("Distance to player: ", distance)
		if distance <= shoot_range:
			is_player_nearby = true
			print("Player is nearby!")
		else:
			is_player_nearby = false
			print("Player is not nearby!")
	else:
		print("Player is not assigned!")

func aim_at_player():
	if player:
		var direction = (player.global_position - global_position).normalized()
		rotation = direction.angle()
		print("Aiming at player: ", direction)

func shoot():
	var bullet = bullet_scene.instantiate()
	print("Shooting bullet!")
	get_parent().add_child(bullet)
	bullet.global_position = gun_marker.global_position
	var direction = (player.global_position - gun_marker.global_position).normalized()
	bullet.set_direction(direction)
