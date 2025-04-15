extends CanvasLayer

var health = 3

func _ready():
	$health.text = "Health: " + str(health)

func _physics_process(delta: float) -> void:
	$health.text = "Health: " + str(health)
	if health <= 0:
		get_tree().reload_current_scene()
	pass
