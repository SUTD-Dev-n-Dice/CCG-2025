extends Node

func _on_bullet_walls_area_entered(area: Area2D) -> void:
	var bullet = area.get_parent()
	print("Debug: " + bullet.name)
	if bullet.is_in_group("Bullet"):
		print("Debug: Area delete")
		bullet.destroy_bullet()
	pass # Replace with function body.


func _on_bullet_walls_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Bullet")):
		print("Debug: Body delete")
		body.destroy_bullet()
	pass # Replace with function body.
