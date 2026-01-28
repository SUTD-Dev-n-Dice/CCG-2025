extends Node

var game_manager : Node

@onready var timer_label: Label = $RoundTimer
@onready var player_1_health_bar: TextureProgressBar = $Player1/Player1Health
@onready var player_2_health_bar: TextureProgressBar = $Player2/Player2Health

func _ready():
	game_manager = get_tree().get_current_scene().get_node("GameManager")

# TODO: Input all logic to change player health, avatar icons and round timer update

func _process(delta):
	timer_label.text = str(ceil(game_manager.get_time_left()))
	player_1_health_bar.value = game_manager.get_player_1_health()
	player_2_health_bar.value = game_manager.get_player_2_health()
