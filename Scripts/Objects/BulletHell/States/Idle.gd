extends EnemyState

var time : float
var timer : Timer

func enter(previous_state_path: String, data := {}) -> void:
	time = 1
	setup_timer()
	print("Entered Idle State")

func physics_update(delta: float) -> void:
	pass

func setup_timer() -> void:
	timer = get_child(0)
	print(timer.name)
	timer.wait_time = time
	timer.start()

func _on_timer_timeout() -> void:
	finished.emit(CHARGE)
