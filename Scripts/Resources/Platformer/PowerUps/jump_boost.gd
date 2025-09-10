class_name PowerResourceJumpBoost
extends PowerResource

func effect(p:PlatformerPlayer) -> void:
	player = p
	player.jump_mult = 1.5
