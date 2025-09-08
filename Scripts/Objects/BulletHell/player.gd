extends CharacterBody2D

#region Class Preloads
const Player = preload("res://Scripts/Objects/BulletHell/Player.gd")
const PlayerSpike = preload("res://Scripts/Objects/BulletHell/PlayerSpike.gd")
const PlayerShockwave = preload("res://Scripts/Objects/BulletHell/PlayerShockwave.gd")
const GameManager = preload("res://Scripts/Objects/BulletHell/GameManager.gd")

const PLAYER_SPIKE_SCENE = preload("res://Scenes/Objects/BulletHell/player_spike.tscn")
const PLAYER_SHOCKWAVE_SCENE = preload("res://Scenes/Objects/BulletHell/player_shockwave.tscn")
#endregion

enum PlayerState { GROUNDED, FALLING }
const PlayerName = {
	ONE = "Player1",
	TWO = "Player2",
}

@export_group("Input Map")
@export var left: StringName
@export var right: StringName
@export var up: StringName
@export var down: StringName
@export var jump: StringName
@export var spike: StringName
@export var wave: StringName

@export_group("References")
@export var other: Player

@onready var game_manager: GameManager = get_node("/root/BulletHell")

var healthQuarts: float = 12.0
var maxHealthQuarters: int = 12
var canTakeDamage := true
var damageCooldown := 0.5   # invulnerability timing in seconds
var shockwave: PlayerShockwave = null
signal health_changed(player: String, health: float)
signal game_end

#region Shared Internals
var shared = SharedState.get_instance()
class SharedState extends RefCounted:
	static var _instance: SharedState
	var spike: PlayerSpike
	
	func _init():
		if _instance != null:
			printerr("attempted creation of second SharedState instance")
			return
		_instance = self
		spike = null

	func create_spike(creator: Player) -> PlayerSpike:
		if spike != null:
			return null

		spike = PLAYER_SPIKE_SCENE.instantiate()
		spike.player = creator
		spike.tracker = self
		return spike

	static func get_instance() -> SharedState:
		if _instance == null:
			_instance = SharedState.new()
		return _instance
#endregion

#region Sprite Internals
var _sprite_original_scale: float
var _sprite_scale: float:
	get:
		return $Sprite2D.scale.x / _sprite_original_scale
	set(new_scale):
		$Sprite2D.z_index = new_scale * 100
		$Sprite2D.scale.x = _sprite_original_scale * new_scale
		$Sprite2D.scale.y = _sprite_original_scale * new_scale

func _sprite_init_scale():
	_sprite_original_scale = $Sprite2D.scale.x

func _sprite_update_state(state: PlayerState):
	_sprite_scale = {
		PlayerState.GROUNDED: 1.0,
		PlayerState.FALLING: 1.5,
	}[state]

func _sprite_process_delta(delta: float):
	if state == PlayerState.FALLING:
		_sprite_scale -= delta
		if _sprite_scale <= 1.0:
			update_state(PlayerState.GROUNDED)
#endregion

#region State Internals
var running: bool:
	get: return not game_manager.getState(); # getState returns isEnded
var state: PlayerState = PlayerState.GROUNDED

func update_state(new_state: PlayerState):
	state = new_state
	_sprite_update_state(new_state)
#endregion

func _ready():
	_sprite_init_scale()

func _process_input():
	# movement
	var input_direction = Input.get_vector(left, right, up, down).normalized()
	velocity = input_direction * 400

	# use name as the indicator for current player
	if name == PlayerName.ONE:
		game_manager.setPlayer1Position(position)
	elif name == PlayerName.TWO:
		game_manager.setPlayer2Position(position)

	# jump
	if Input.is_action_just_pressed(jump) and state == PlayerState.GROUNDED:
		update_state(PlayerState.FALLING)

	# spike
	if Input.is_action_just_pressed(spike) and other != null:
		var spike = shared.create_spike(self)
		if spike:
			game_manager.add_child(spike)

	# shockwave
	if Input.is_action_just_pressed(wave) and shockwave == null:
		shockwave = PLAYER_SHOCKWAVE_SCENE.instantiate()
		shockwave.player = self
		game_manager.add_child(shockwave)

func _process(delta):
	if not running:
		return

	_process_input()

func _physics_process(delta):
	if not running:
		return

	move_and_slide()
	_sprite_process_delta(delta)

	# check for damage events
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is CharacterBody2D && collider.is_in_group("Enemy"):
			velocity = Vector2.ZERO
			take_damage()
			return 0

func take_damage():
	if not canTakeDamage:
		return
	canTakeDamage = false

	healthQuarts -= 1.0
	emit_signal("health_changed", healthQuarts) # connected in game manager to heartsUI
	print("Player hit! Health now:", healthQuarts)

	if healthQuarts == 0.0:
		emit_signal("game_end")

	# start cooldown timer
	var t = get_tree().create_timer(damageCooldown)
	t.timeout.connect(func(): canTakeDamage = true)
