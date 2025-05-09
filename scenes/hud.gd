extends CanvasLayer

var health = 10
var ammo = 10
var ammo_max = 10
var ammo_reload = false
func _ready():
	$health.text = "Health: " + str(health)
	$ammo.text = "ammo: " + str(ammo) + "/10"
func _physics_process(delta: float) -> void:
	if ammo_reload == true:
		$ammo.text = "ammo: reloading..."
	else:
		$ammo.text = "ammo: " + str(ammo) + "/10"
	$health.text = "Health: " + str(health)
pass
