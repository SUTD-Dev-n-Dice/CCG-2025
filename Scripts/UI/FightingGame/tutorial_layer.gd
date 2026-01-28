extends CanvasLayer

var p1_ready := false
var p2_ready := false

var game_manager : Node

@onready var player_1_sprite : TextureRect = $"SceneBG/Player 1"
@onready var player_2_sprite : TextureRect = $"SceneBG/Player 2"

@export var player_1_sprites: Array[Texture2D]
@export var player_2_sprites: Array[Texture2D]

func _ready():
	game_manager = get_tree().get_current_scene().get_node("GameManager")

func _process(delta: float) -> void:
	# Player 1 presses key 'z'
	if not p1_ready and Input.is_action_just_pressed("z"):
		p1_ready = true
		show_ready_feedback(1)
		check_start()
		
	# Player 2 presses key 'm'
	if not p2_ready and Input.is_action_just_pressed("m"):
		p2_ready = true
		show_ready_feedback(2)
		check_start()

func show_ready_feedback(player_num: int) -> void:
	if player_num == 1:
		$SceneBG/P1Ready.text = "READY!"
	else:
		$SceneBG/P2Ready.text = "READY!"

func check_start():
	if p1_ready and p2_ready:
		game_manager.tutorial_complete()
		

# Helper: Change player sprite according to buttons pressed in tutorial panel
func set_player_1_sprite(name : String) -> void:
	match name:
		"left1":
			player_1_sprite.texture = player_1_sprites[1]
		"right1":
			player_1_sprite.texture = player_1_sprites[2]
		"up1":
			player_1_sprite.texture = player_1_sprites[3]
		"down1":
			player_1_sprite.texture = player_1_sprites[4]
		_: # default: idle
			player_1_sprite.texture = player_1_sprites[0]

func set_player_2_sprite(name : String) -> void:
	match name:
		"left2":
			player_1_sprite.texture = player_1_sprites[1]
		"right2":
			player_1_sprite.texture = player_1_sprites[2]
		"up2":
			player_1_sprite.texture = player_1_sprites[3]
		"down2":
			player_1_sprite.texture = player_1_sprites[4]
		_: # default: idle
			player_1_sprite.texture = player_1_sprites[0]
