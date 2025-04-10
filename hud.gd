extends CanvasLayer

var health = 3

func _ready():
	$health.text = "Health: " + str(health)
	
	
