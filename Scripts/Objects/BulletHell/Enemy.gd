class_name Enemy extends CharacterBody2D

var angerLevel : int = 50		# anger intensity controls frequency of attacks (increase chance for double attack)
var type : String			# type of vehicle, affects sprites later

var healthQuarts: float = 32.0
var maxHealthQuarters: int = 32
signal health_changed(enemy: String, health: float)
signal game_win

# Staggered damage protection from spike
var canDamage: bool = true
var damageCooldown := 0.5   # invulnerability timing in seconds

#region Sprite
var _sprite_flash_modifier: float = 0
var _sprite_shader: ShaderMaterial:
	get: return $AnimatedSprite2D.material

func _sprite_process_delta(delta: float):
	_sprite_flash_modifier = move_toward(_sprite_flash_modifier, 0,
		delta * (1 / damageCooldown))
	_sprite_shader.set_shader_parameter("flash_modifier", _sprite_flash_modifier)

func _sprite_flash():
	_sprite_flash_modifier = 1
#endregion

@onready var game_manager = get_node("/root/BulletHell")
var bullet = preload("res://Scenes/Objects/BulletHell/bullet.tscn")

var bulletDamage : int  = 5
var target_position : CharacterBody2D
var speed: float = 500.0

var stateMachine : StateMachine

func getAnger() -> int:
	return angerLevel

func changeAnger(angerModifier : int) -> void:
	angerLevel += angerModifier

func bulletDamaged() -> void:
	if not canDamage:
		return
	canDamage = false
		
	healthQuarts -= 1.0
	emit_signal("health_changed", healthQuarts) # connected in game manager to heartsUI
	print("[DEBUG] enemy health: ", healthQuarts)

	_sprite_flash()

	if healthQuarts == 0.0:
		emit_signal("game_win")
	
	# start cooldown timer
	var t = get_tree().create_timer(damageCooldown)
	t.timeout.connect(reset_iframe)

func reset_iframe():
	canDamage = true

func set_target_position(player : String) -> void:
	if player == "1":
		target_position = game_manager.player1Pos
	else:
		target_position = game_manager.player2Pos
	
func move_to_player() -> int:	
	var direction: Vector2 = (target_position.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	# Case 1: If it hits the player, go back to idle
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is CharacterBody2D && collider.is_in_group("Player"):
			velocity = Vector2.ZERO
			return 0

	#Case 2: If it reaches target position, go back to idle
	if (target_position.global_position.distance_to(position) < 5):
		return 1
	else:
		return 2

func spawn_bullet() -> void:
	var _bullet = bullet.instantiate()

	# set bullet movement variables (target location, etc.)
	var movement = _bullet.get_node("Movement")
	if movement:
		movement.init(target_position)
		movement.initial_speed = 5
		movement.acceleration = 5
		
	# set bullet damage variables
	var damage = _bullet.get_node("Damage")
	if damage:
		damage.atk = 1.0
		
	_bullet.position = position
	get_tree().current_scene.add_child(_bullet)

func _physics_process(delta):
	_sprite_process_delta(delta);
