class_name PlatformerPlayer
extends CharacterBody2D

@export var player_1:bool = true

## Adjustable Constants
const base_speed:int = 300
const buffer_time:float = 0.3
const max_jump_duration:float = 0.2
const jump_duration_fading:float = 10.0
const coyote_time:float = 0.3

const jump_power:int = 650
const gravity:int = 2400

## Powerup Variables
var jump_mult:float = 1.0

## Movement Variables
var dir: Vector2 = Vector2.ZERO
var speed:float = 0

## Jump Variables
var jump_buffer:float = 0
var jump_time:float = 0
var jumping:bool = false
var jump_number:int = 0
var time_in_air:float = 0

var can_move:bool = false

signal die

func _ready() -> void:
	speed = base_speed
	
	if !player_1:
		$Sprite2D.modulate = Color(0,0,1,1)

func go():
	can_move = true

func _physics_process(delta: float) -> void:
	var jump_button:String = "c"
	if can_move:
		if player_1:
			dir.x = Input.get_axis("left1", "right1")
		else:
			dir.x = Input.get_axis("left2", "right2")
			jump_button = "."
	
	dir.x *= speed
	
	if Input.is_action_pressed(jump_button) and can_move:
		jump_buffer += delta
	else:
		jump_buffer = 0
		jumping = false
	
	if jump_buffer > 0 and jump_buffer <= buffer_time:
		if time_in_air < coyote_time and jump_number == 0:
			jumping = true
			jump_number += 1
			
	if jumping and jump_buffer > 0:
		jump(delta)
	else:
		jump_time = 0
	
	velocity = dir
	move_and_slide()
	
	if is_on_floor():
		dir.y = 0
		time_in_air = 0
		jumping = false
		jump_number = 0
	else:
		dir.y += gravity* delta
		time_in_air += delta


func jump(delta: float):
	dir.y = - jump_mult * jump_power * (max_jump_duration - jump_time/jump_duration_fading)/max_jump_duration
	jump_time += delta
	if jump_time > max_jump_duration:
		jumping = false
		jump_buffer = 0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die.emit()

func powerup(powerup:PowerResource):
	powerup.effect(self)
