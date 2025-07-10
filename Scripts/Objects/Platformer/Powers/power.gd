class_name Power
extends Node2D

var dir: Vector2 = Vector2(0,1)
@export var speed:int = 200
var time:float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	dir.x = sin(time)
	global_position += dir * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body is Player_Platformer:
		body.powerup()
