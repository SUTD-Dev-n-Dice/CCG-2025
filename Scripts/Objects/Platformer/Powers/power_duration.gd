class_name PlatformerPowerDuration
extends TextureProgressBar


var duration:float = 5
var resource:PowerResource
var player:PlatformerPlayer

func start(res:PowerResource, p:PlatformerPlayer) -> void:
	resource = res
	player = p
	duration = res.duration
	max_value = res.duration * 100

func _process(delta: float) -> void:
	duration -= delta
	value = duration * 100
	
	if duration < 0:
		resource.remove_effect(player)
		player.remove_powerup(resource)
		queue_free()
