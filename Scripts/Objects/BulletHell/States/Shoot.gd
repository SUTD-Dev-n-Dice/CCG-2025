extends EnemyState

var anger : float
var bullets : int

var canShoot : bool = true

var players : Array[String] = ["1", "2"]

func enter(previous_state_path: String, data := {}) -> void:
	anger = get_parent().get_parent().angerLevel
	get_parent().get_parent().set_target_position(players[randi() % 2])
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
	
	get_parent().get_parent().spawn_bullet()
	
	# start cooldown timer
	var t = get_tree().create_timer(0.5)
	t.timeout.connect(func(): canShoot = true)
