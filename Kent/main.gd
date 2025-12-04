extends Node3D

@onready var player1 = $Player
@onready var player2 = $player2
@onready var hitbox1 = $Player/area1
@onready var hitbox2 = $player2/area2
# --- Repulsion Variables ---
const push = -10.0   # The strength of the push (meters per second)

func _physics_process(delta):
	#make players face each other
	if player1.global_position.x < player2.global_position.x:
		if not player1.velocity.x == -14:
			player1.scale.x = 1
		if not player2.velocity.x == 14:
			player2.scale.x = 1
	elif player1.global_position.x > player2.global_position.x:
		if not player1.velocity.x == 14:
			player1.scale.x = -1
		if not player2.velocity.x == -14:
			player2.scale.x = -1
			
	#pushing physics
	var direction1 = Vector3.ZERO
	var direction2 = Vector3.ZERO
	
	var collision1 = hitbox1.get_overlapping_areas()
	if not collision1.is_empty():
		if abs(player1.velocity.x) == 14 or abs(player2.velocity.x) == 14:
			direction1.x += player1.scale.x * push
			player1.move_character(direction1, 1.55)
			direction2.x -= player1.scale.x * push
			player2.move_character(direction2, 1.55)
		else:
			direction1.x += player1.scale.x * push
			player1.move_character(direction1, 0.4)
			direction2.x -= player1.scale.x * push
			player2.move_character(direction2, 0.4)
