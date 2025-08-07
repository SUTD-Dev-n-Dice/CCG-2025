class_name Enemy extends CharacterBody2D

var angerLevel : int = 50		# anger intensity controls frequency of attacks (increase chance for double attack)
var health : int = 100			# health of enemy vehicle
var type : String			# type of vehicle, affects sprites later

var bulletDamage : int  = 5

var stateMachine : StateMachine

func getAnger() -> int:
	return angerLevel

func changeAnger(angerModifier : int) -> void:
	angerLevel += angerModifier

func bulletDamaged() -> void:
	health -= 5
	
	# TODO: handle if health reaches below threshold
	
func _physics_process(delta):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			if collision.is_in_group("Bullet"):
				bulletDamaged()		
