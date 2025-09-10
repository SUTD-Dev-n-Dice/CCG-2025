extends Platform

var players_in_range:Array[PlatformerPlayer]

var power_node = preload("res://Scenes/Objects/Platformer/Powers/power.tscn")

@export var powers:Array[PowerResource]

func _physics_process(delta: float) -> void:
	for player in players_in_range:
		if player.dir.y >= 0 and player.global_position.y < global_position.y:
			players_in_range.erase(player)
			spawn_power()

func spawn_power() -> void:
	var p:Power = power_node.instantiate()
	p.power = powers.pick_random().duplicate()
	add_child(p)
	p.position = Vector2(0,100)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlatformerPlayer:
		players_in_range.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is PlatformerPlayer:
		if body in players_in_range:
			players_in_range.erase(body)
