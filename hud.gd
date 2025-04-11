extends CanvasLayer

var health = 3

func _ready():
	$health.text = "Health: " + str(health)

func _process(delta: float) -> void:
	$health.text = "Health: " + str(health)

	if health < 1:
		get_tree().reload_current_scene()
	
	
