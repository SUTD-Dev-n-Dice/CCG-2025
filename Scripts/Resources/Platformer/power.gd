class_name PowerResource
extends Resource

var player:PlatformerPlayer

func effect(p:PlatformerPlayer) -> void:
	player = p
	push_error("Effect has not been established")
