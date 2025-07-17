extends Platform

var players_in_range:Array[PlatformerPlayer]
var is_crumbling:bool = false

func _physics_process(delta: float) -> void:
	if is_crumbling: return
	for player in players_in_range:
		if player.dir.y >= 0 and player.global_position.y < global_position.y:
			Crumbling()

func Crumbling():
	$AnimationPlayer.play("crumble")
	is_crumbling = true
	await get_tree().create_timer(1.0).timeout
	%CollisionShape2D.disabled = true
	await get_tree().create_timer(3.0).timeout
	$AnimationPlayer.play("spawn")
	await get_tree().create_timer(1.0).timeout
	%CollisionShape2D.disabled = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlatformerPlayer:
		players_in_range.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is PlatformerPlayer:
		players_in_range.erase(body)
