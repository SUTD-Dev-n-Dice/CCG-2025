extends Node2D

@export var platform_nodes:Array[PackedScene] = []
@export var player:Node2D

var last_pos_y:int = 0

func _ready() -> void:
	for i in 100:
		var pos_y_random:int = randi_range(50, 101 + i)
		var pos_x_random:int = randi_range(-201 - i, 201 + i)
		var number_of_platforms:int = 1
		if pos_x_random > 150:
			number_of_platforms = 2
		for j in number_of_platforms:
			var platform_instance:Platform = platform_nodes.pick_random().instantiate()
			$Platforms.add_child(platform_instance)
			platform_instance.global_position.y = last_pos_y - pos_y_random
			platform_instance.global_position.x = pos_x_random * 2 * (0.5 - j)
		last_pos_y -= pos_y_random

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass


func _on_player_1_die() -> void:
	get_tree().paused = true
	$CanvasLayer/Player2Win.show()


func _on_player_2_die() -> void:
	get_tree().paused = true
	$CanvasLayer/Player1Win.show()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
