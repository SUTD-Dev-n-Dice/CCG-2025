extends Node2D

@export_custom(PROPERTY_HINT_FILE, "*.tscn") var PlatformerScenePath: String
@export_custom(PROPERTY_HINT_FILE, "*.tscn") var BulletHellScenePath: String

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("c") or Input.is_action_just_pressed("."):
		get_tree().change_scene_to_file(PlatformerScenePath)
	elif Input.is_action_just_pressed("v") or Input.is_action_just_pressed("slash"):
		get_tree().change_scene_to_file(BulletHellScenePath)
