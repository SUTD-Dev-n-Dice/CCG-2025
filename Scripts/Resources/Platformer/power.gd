class_name PowerResource
extends Resource

var duration:float = 3.0
var player:PlatformerPlayer

func effect(p:PlatformerPlayer) -> void:
	player = p
	push_error("Effect has not been established")
