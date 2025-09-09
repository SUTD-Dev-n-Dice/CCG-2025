extends CharacterBody2D
class_name PlayerBulletHell

enum PlayerState { GROUNDED, FALLING }

@export_group("Input Map")
@export_subgroup("Movement")
@export var left: StringName
@export var right: StringName
@export var up: StringName
@export var down: StringName
@export_subgroup("Action")
@export var jump: StringName

@onready var game_manager = get_node("/root/BulletHell")

var healthQuarts: float = 12.0
var maxHealthQuarters: int = 12
var canTakeDamage := true
var damageCooldown := 0.5   # invulnerability timing in seconds
signal health_changed(player: String, health: float)
signal game_end

const ORIGINAL_SCALE = Vector2(1, 1)
const JUMP_SCALE = Vector2(1.5, 1.5)

var state: PlayerState = PlayerState.GROUNDED
@export var health: int = 1000000

func _ready():
	if name == "Player1":
		game_manager.setPlayer1Position(self)
	elif name == "Player2":
		game_manager.setPlayer2Position(self)

func update_state(new_state: PlayerState):
	state = new_state
	match state:
		PlayerState.GROUNDED:
			$CollisionShape2D.disabled = false
			scale = ORIGINAL_SCALE
		PlayerState.FALLING:
			$CollisionShape2D.disabled = true
			scale = JUMP_SCALE

func process_input():
	# movement
	var input_direction = Input.get_vector(left, right, up, down).normalized()
	velocity = input_direction * 400
		
	# jump
	if (state == PlayerState.GROUNDED and Input.is_action_just_pressed(jump)):
		update_state(PlayerState.FALLING)

func _process(delta):
	if not game_manager.getState():
		process_input()

func _physics_process(delta):
	if game_manager.getState():
		return
	
	move_and_slide()
	if (state == PlayerState.FALLING):
		scale.x -= delta
		scale.y = scale.x
		if (scale <= ORIGINAL_SCALE):
			update_state(PlayerState.GROUNDED)
		$Sprite2D.z_index = scale.x * 100
	
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
		
	if dmg == 0.0:
		print("[DEBUG] No damage dealt")
		return
	
	canTakeDamage = false
	healthQuarts -= 1.0
	emit_signal("health_changed", healthQuarts) # connected in game manager to heartsUI
	print("[DEBUG] health: ", healthQuarts)
	
	if healthQuarts == 0.0:
		emit_signal("game_end")
	
	# start cooldown timer
	var t = get_tree().create_timer(damageCooldown)
	t.timeout.connect(func(): canTakeDamage = true)

func proc_bullet_enter(bullet: Bullet):
	var damage_source: DamageSource = bullet.get_node("Damage")
	var dmg = damage_source.on_hit(self)
	take_damage(dmg)

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
