extends MeshInstance3D

func _physical_proccess():
	if Input.is_action_pressed("Left"):
		position += Vector3(5,0,0)
