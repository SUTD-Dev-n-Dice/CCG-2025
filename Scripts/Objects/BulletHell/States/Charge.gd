extends EnemyState

func enter(previous_state_path: String, data := {}) -> void:
	print("Entered Charge State")
	pass

# TODO: Function to move towards last player position player

func physics_update(delta: float) -> void:
	# temp
	if Input.is_action_just_pressed("z"):
		finished.emit(SHOOT)
