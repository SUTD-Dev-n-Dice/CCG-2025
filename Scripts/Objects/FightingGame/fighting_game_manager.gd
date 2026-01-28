extends Node

## GAME VARIABLES
enum GameState { TUTORIAL, ROUND1, ROUND2, ROUND3, FINISH, PAUSE }
@export var current_state: GameState
@export var prev_state: GameState

## UI LAYERS
@export var tutorial_canvas: CanvasLayer
@export var round_canvas: CanvasLayer
@export var pause_canvas: CanvasLayer
@export var finish_canvas: CanvasLayer

## GAME TIMER
@export var round_time: float = 90.0
@onready var round_timer: Timer = $GameTimer

## PLAYER HEALTH
@export var max_health: float = 100.0
@export var player_1_health: float = 100.0
@export var player_2_health: float = 100.0

## GAME START
func _ready() -> void:
	update_ui_layer()

# Helper: Change to new game state
func set_state(state: GameState) -> void:
	prev_state = current_state
	current_state = state
	update_ui_layer()
	handle_state_timer()

# Helper: Update UI from current state
func update_ui_layer() -> void:
	tutorial_canvas.visible = (current_state == GameState.TUTORIAL)
	round_canvas.visible    = (current_state in [GameState.ROUND1, GameState.ROUND2, GameState.ROUND3])
	pause_canvas.visible    = (current_state == GameState.PAUSE)
	finish_canvas.visible   = (current_state == GameState.FINISH)

## GAMEPLAY FLOW UPDATE
# Called from --
func tutorial_complete() -> void:
	set_state(GameState.ROUND1)

# Called from --
func round_complete() -> void:
	match current_state:
		GameState.ROUND1:
			set_state(GameState.ROUND2)
		GameState.ROUND2:
			set_state(GameState.ROUND3)
		GameState.ROUND3:
			set_state(GameState.FINISH)

## PLAYER HEALTH
func player_1_hurt(deduction:float) -> void:
	player_1_health -= deduction
	
	if player_1_health <= 0:
		# END ROUND LOGIC - PLAYER 2 WIN
		pass
	
func player_2_hurt(deduction:float) -> void:
	player_2_health -= deduction
	
	if player_2_health <= 0:
		# END ROUND LOGIC - PLAYER 1 WIN
		pass

func reset_player_health() -> void:
	player_1_health = max_health
	player_2_health = max_health
	
# Helper: Allow round canvas to access player health to display
func get_player_1_health() -> float:
	return player_1_health

func get_player_2_health() -> float:
	return player_2_health

## GAME TIMER
func handle_state_timer() -> void:
	if current_state in [GameState.ROUND1, GameState.ROUND2, GameState.ROUND3]:
		start_round_timer()
	else:
		round_timer.stop()

func start_round_timer():
	round_timer.stop()
	round_timer.wait_time = round_time
	round_timer.start()
	
# Helper: Allow round canvas to access game timer to display
func get_time_left() -> float:
	return round_timer.time_left

## CUSTOM PAUSE
# allow cutscenes to play without affecting gameplay timer, if we want to implement animations
func pause_game() -> void:
	if current_state != GameState.PAUSE:
		prev_state = current_state
		round_timer.paused = true
		set_state(GameState.PAUSE)
		
func resume_game() -> void:
	set_state(prev_state)
	round_timer.paused = false

func is_gameplay_paused() -> bool:
	return current_state == GameState.PAUSE

func _on_game_timer_timeout() -> void:
	# END ROUND LOGIC - LOWEST HEALTH WINS
	pass 
