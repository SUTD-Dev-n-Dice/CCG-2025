extends EnemyState

var anger : float
var bullets : int

var canShoot : bool = true

func enter(previous_state_path: String, data := {}) -> void:
	anger = get_parent().get_parent().angerLevel
	bullets = 5
	print("Entered Shoot State")

func physics_update(delta: float) -> void:
	if bullets == 0:
		finished.emit(IDLE)
	
	shoot()

func shoot() -> void:
	if not canShoot:
		return
	
	canShoot = false
	bullets -= 1
	
	print("Bang!") # temp line, spawn bullet here
	
	# start cooldown timer
	var t = get_tree().create_timer(0.5)
	t.timeout.connect(func(): canShoot = true)
