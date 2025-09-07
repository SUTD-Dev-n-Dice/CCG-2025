extends Node

# players update this every frame, enemy only accesses when necessary
@export var player1Pos : Vector2 = Vector2.ZERO
@export var player2Pos : Vector2 = Vector2.ZERO

var player1: CharacterBody2D
var player2: CharacterBody2D
var heartsUI1: HBoxContainer
var heartsUI2: HBoxContainer

# the boolean that controls whether the entire game is running
var isEnd: bool = false

func _ready():
	player1 = get_node("Player1")  # adjust path relative to GameManager
	player2 = get_node("Player2")
	heartsUI1 = get_node("GameUI/Player1UI/HBoxContainer")
	heartsUI2 = get_node("GameUI/Player2UI/HBoxContainer")
	
	heartsUI1.init_ui(player1.maxHealthQuarters)
	player1.health_changed.connect(heartsUI1.update_hearts)
	player1.game_end.connect(game_end)
	
	heartsUI2.init_ui(player2.maxHealthQuarters)
	player2.health_changed.connect(heartsUI2.update_hearts)
	player2.game_end.connect(game_end)

func setPlayer1Position(pos: Vector2) -> void:
	player1Pos = pos
	
func setPlayer2Position(pos: Vector2) -> void:
	player2Pos = pos

func getState() -> bool:
	return isEnd
	
func game_start():
	pass
	
func game_end():
	isEnd = true
