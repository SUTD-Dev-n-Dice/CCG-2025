extends Node


func _on_top_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Bullet")):
		# TODO: call bullet's destroy function
		pass

func _on_bottom_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Bullet")):
		# TODO: call bullet's destroy function
		pass

func _on_left_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Bullet")):
		# TODO: call bullet's destroy function
		pass

func _on_right_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Bullet")):
		# TODO: call bullet's destroy function
		pass
