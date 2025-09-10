extends Node

# players update this every frame, enemy only accesses when necessary
@export var player1Pos : CharacterBody2D
@export var player2Pos : CharacterBody2D

var player1: CharacterBody2D
var player2: CharacterBody2D
var enemy: CharacterBody2D
var heartsUI1: HBoxContainer
var heartsUI2: HBoxContainer
var enemyHeartsUI: HBoxContainer

var gameOverUI: ColorRect

# the boolean that controls whether the entire game is running
var isEnd: bool = false

func _ready():
	player1 = get_node("Player1")  # adjust path relative to GameManager
	player2 = get_node("Player2")
	heartsUI1 = get_node("GameUI/Player1UI/HBoxContainer")
	heartsUI2 = get_node("GameUI/Player2UI/HBoxContainer")
	gameOverUI = get_node("GameUI/GameOver")
	
	enemy = get_node("Enemy")
	enemyHeartsUI = get_node("GameUI/EnemyUI/HBoxContainer")
	
	heartsUI1.init_ui(player1.maxHealthQuarters)
	player1.health_changed.connect(heartsUI1.update_hearts)
	player1.game_end.connect(game_end)
	
	heartsUI2.init_ui(player2.maxHealthQuarters)
	player2.health_changed.connect(heartsUI2.update_hearts)
	player2.game_end.connect(game_end)
	
	enemyHeartsUI.init_ui(enemy.maxHealthQuarters)
	enemy.health_changed.connect(enemyHeartsUI.update_hearts)
	enemy.game_win.connect(game_win)

func setPlayer1Position(pos: Node2D) -> void:
	player1Pos = pos
	
func setPlayer2Position(pos: Node2D) -> void:
	player2Pos = pos

func getState() -> bool:
	return isEnd
	
func game_start():
	pass
	
func game_end():
	isEnd = true
	gameOverUI.visible = true
	gameOverUI.get_child(0).set_text("You lost!")
	
func game_win():
	isEnd = true
	gameOverUI.visible = true
	gameOverUI.get_child(0).set_text("You win!")

func _on_return_button_down() -> void:
	# TODO: Add function to go to the main menu
	pass # Replace with function body.

func _on_retry_button_down() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
