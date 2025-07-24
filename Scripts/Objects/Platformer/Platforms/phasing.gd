extends Platform

const alpha_active: float = 0.3

var time:float = 0

func _physics_process(delta: float) -> void:
	time += delta
	var x:float = sin(time) * sin(time)
	
	if x > alpha_active:
		%CollisionShape2D.disabled = false
		modulate.a = x
	else:
		%CollisionShape2D.disabled = true
		modulate.a = 0
