extends CharacterBody2D
class_name PlayerBulletHell

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
@export var profileSprite: TextureRect
@export var normal_texture: Texture2D
@export var hurt_texture: Texture2D

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
var _sprite_flash_modifier: float = 0
var _sprite_shader: ShaderMaterial:
	get: return $Sprite2D.material

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
	profileSprite.texture = normal_texture

func _sprite_update_state(state: PlayerState):
	_sprite_scale = {
		PlayerState.GROUNDED: 1.0,
		PlayerState.FALLING: 1.5,
	}[state]

func _sprite_process_delta(delta: float):
	_sprite_flash_modifier = move_toward(_sprite_flash_modifier, 0,
		delta * (1 / damageCooldown))
	_sprite_shader.set_shader_parameter("flash_modifier", _sprite_flash_modifier)

	if state == PlayerState.FALLING:
		_sprite_scale -= delta
		if _sprite_scale <= 1.0:
			update_state(PlayerState.GROUNDED)

func _sprite_flash():
	_sprite_flash_modifier = 1
#endregion

#region State Internals
var running: bool:
	get: return not game_manager.getState(); # getState returns isEnded
var state: PlayerState = PlayerState.GROUNDED
@export var health: int = 1000000

func _ready():
	_sprite_init_scale()
	
	if name == PlayerName.ONE:
		game_manager.setPlayer1Position(self)
	elif name == PlayerName.TWO:
		game_manager.setPlayer2Position(self)

func update_state(new_state: PlayerState):
	state = new_state
	_sprite_update_state(new_state)
#endregion

func _process_input():
	# movement
	var input_direction = Input.get_vector(left, right, up, down).normalized()
	velocity = input_direction * 400

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
			take_damage(1.0)
			return 0

func take_damage(dmg):
	if not canTakeDamage:
		return
	if state != PlayerState.GROUNDED:
		return

	if dmg == 0.0:
		print("[DEBUG] No damage dealt")
		return
	
	canTakeDamage = false
	healthQuarts -= 1.0
	emit_signal("health_changed", healthQuarts) # connected in game manager to heartsUI
	print("[DEBUG] health: ", healthQuarts)
	
	_sprite_flash()
	profileSprite.texture = hurt_texture

	if healthQuarts == 0.0:
		emit_signal("game_end")

	# start cooldown timer
	var t = get_tree().create_timer(damageCooldown)
	t.timeout.connect(reset_iframe)

func reset_iframe():
	canTakeDamage = true
	profileSprite.texture = normal_texture

func proc_bullet_enter(bullet: Bullet):
	var damage_source: DamageSource = bullet.get_node("Damage")
	var dmg = damage_source.on_hit(self)
	take_damage(dmg)
	
	# NEW: Delete bullet
	bullet.destroy_bullet()

func proc_bullet_leave(bullet: Bullet):
	var damage_source: DamageSource = bullet.get_node("Damage")
	damage_source.on_leave(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	var other = area.get_parent()
	if other is Bullet:
		proc_bullet_enter(other)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var other = area.get_parent()
	if other is Bullet:
		proc_bullet_leave(other)
