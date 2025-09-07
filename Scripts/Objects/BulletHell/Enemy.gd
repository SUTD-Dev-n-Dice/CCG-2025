class_name Enemy extends CharacterBody2D

var angerLevel : int = 50		# anger intensity controls frequency of attacks (increase chance for double attack)
var health : int = 100			# health of enemy vehicle
var type : String			# type of vehicle, affects sprites later

@onready var game_manager = get_node("/root/BulletHell")

var bulletDamage : int  = 5
var target_position : Vector2
var speed: float = 500.0

var stateMachine : StateMachine

func getAnger() -> int:
	return angerLevel

func changeAnger(angerModifier : int) -> void:
	angerLevel += angerModifier

func bulletDamaged() -> void:
	health -= 5
	
	# TODO: handle if health reaches below threshold
	
func set_target_position(player : String) -> void:
	if player == "1":
		target_position = game_manager.player1Pos
	else:
		target_position = game_manager.player2Pos
	
func move_to_player() -> int:	
	var direction: Vector2 = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	# Case 1: If it hits the player, go back to idle
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is CharacterBody2D && collider.is_in_group("Player"):
			velocity = Vector2.ZERO
			return 0
	
	#Case 2: If it reaches target position, go back to idle
	if (target_position.distance_to(position) < 5):
		return 1
	else:
		return 2
