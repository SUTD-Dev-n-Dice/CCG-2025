extends ColorRect

## Player Button Colours (proof of concept)
var original_color = Color(1, 1, 1, 1) # White
var pressed_color = Color(1, 0, 0, 1)  # Red

@export var key_name : String
@export var player : int
@onready var tutorial_script = get_parent().get_parent().get_parent()

func _process(delta):
	if Input.is_action_just_pressed(key_name):
		self.color = pressed_color
		if player == 1:
			#tutorial_script.set_player_1_sprite(key_name)
			pass
		else:
			#tutorial_script.set_player_2_sprite(key_name)
			pass
	elif Input.is_action_just_released(key_name):
		self.color = original_color
		if player == 1:
			#tutorial_script.set_player_1_sprite("idle")
			pass
		else:
			#tutorial_script.set_player_2_sprite("idle")
			pass
