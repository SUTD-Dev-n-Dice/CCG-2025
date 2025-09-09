## Lets 
extends Node

@export var target_location: Node2D

@export var initial_speed: float
@export var acceleration: float

var body: RigidBody2D


## Get unit direction to target_location.
func get_direction():
	var direction = target_location.global_position - body.global_position
	return direction.normalized()

func _ready():
	body = owner as RigidBody2D
	var dir = get_direction()
	body.linear_velocity = dir * initial_speed

func _physics_process(delta: float) -> void:
	var dir = get_direction()
	body.linear_velocity += dir * acceleration
