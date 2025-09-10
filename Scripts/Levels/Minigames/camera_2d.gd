extends Camera2D

@export var player_1:CharacterBody2D
@export var player_2:CharacterBody2D

@export var max_distance:float = 300

const camera_speed:float = 10.0

var target_pos = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var pos_1:float = player_1.global_position.y
	var pos_2:float = player_2.global_position.y
	var highest_pos:float = min(pos_1, pos_2)
	
	var avg_pos = (pos_1 + pos_2)/2
	var min_pos = highest_pos + max_distance
	
	target_pos.y = min(avg_pos, min_pos)
	
	global_position.y = lerp(global_position.y, target_pos.y, delta*camera_speed)
