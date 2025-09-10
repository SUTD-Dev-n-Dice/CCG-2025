extends Node2D

@export var platformer_scene:PackedScene
@export var bullethell_scene:PackedScene

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("c") or Input.is_action_just_pressed("."):
		get_tree().change_scene_to_packed(platformer_scene)
	elif Input.is_action_just_pressed("v") or Input.is_action_just_pressed("slash"):
		get_tree().change_scene_to_packed(bullethell_scene)
