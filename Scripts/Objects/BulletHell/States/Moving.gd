extends EnemyState

func enter(previous_state_path: String, data := {}) -> void:
	print("Entered Moving State")
	pass

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		finished.emit(IDLE)

# currently unused
