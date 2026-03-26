class_name PowerResourceShield
extends PowerResource

func effect(p:PlatformerPlayer) -> void:
	player = p
	player.shield = true

func remove_effect(p:PlatformerPlayer) -> void:
	p.shield = false
