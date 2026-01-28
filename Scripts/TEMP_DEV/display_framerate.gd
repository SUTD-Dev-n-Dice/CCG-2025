extends Label

func _process(delta: float) -> void:
	# Use the Performance singleton for a potentially more optimized approach
	text = "FPS: %d" % Performance.get_monitor(Performance.TIME_FPS)
