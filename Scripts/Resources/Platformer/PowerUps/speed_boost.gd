class_name PowerResourceSpeedBoost
extends PowerResource

func effect(p:PlatformerPlayer) -> void:
	player = p
	player.speed_mult = 2

func remove_effect(p:PlatformerPlayer) -> void:
	p.speed_mult = 1
