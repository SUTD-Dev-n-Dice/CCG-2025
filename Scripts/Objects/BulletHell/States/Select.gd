extends EnemyState

func enter(previous_state_path: String, data := {}) -> void:
	print("Entered Select State")
	choose_attack()

func physics_update(delta: float) -> void:
	pass

func choose_attack() -> void:
	var rand = randi_range(1,10) # can be changed to mess with probability / balance
	
	# shoots 70%, charge 30%
	if rand <= 7:
		finished.emit(SHOOT)
	else:
		finished.emit(CHARGE)	
