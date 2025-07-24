extends EnemyState

var anger : float

func enter(previous_state_path: String, data := {}) -> void:
	var anger = get_parent().get_parent().angerLevel
	print("Entered Shoot State")
	pass

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		finished.emit(DAMAGED)
