class_name Enemy extends Node2D

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
	
	# TOD0: handle if health reaches below threshold

func _on_collision_area_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Bullet")):
		bulletDamaged()
	
