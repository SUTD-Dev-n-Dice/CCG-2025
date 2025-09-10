extends EnemyState

var players : Array[String] = ["1", "2"]

func enter(previous_state_path: String, data := {}) -> void:
	print("Entered Charge State")
	get_parent().get_parent().set_target_position(players[randi() % 2])

func physics_update(delta: float) -> void:
	var collision = get_parent().get_parent().move_to_player() 
	
	if collision == 0:  # if hit player, idle
		finished.emit(IDLE)
	elif collision == 1: # if not, shoot towards player & increase anger (NOT COMPLETE)
		finished.emit(SHOOT)
