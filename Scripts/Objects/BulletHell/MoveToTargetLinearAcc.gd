## Lets 
extends Node

@export var target_location: CharacterBody2D

@export var initial_speed: float
@export var acceleration: float

var body: RigidBody2D

## Get unit direction to target_location.
func get_direction():
	var direction = target_location.global_position - body.global_position
	return direction.normalized()

func init(target: CharacterBody2D) -> void:
	target_location = target

func _ready():
	body = get_parent() as RigidBody2D
	var dir = get_direction()
	body.linear_velocity = dir * initial_speed

func _physics_process(delta: float) -> void:
	var dir = get_direction()
	body.linear_velocity += dir * acceleration
