extends Node
class_name Bullet

func destroy_bullet():
	print("[Debug] Delete Bullet")
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
