extends CharacterBody2D

enum PlayerState { GROUNDED, FALLING }

@export_group("Input Map")
@export_subgroup("Movement")
@export var left: StringName
@export var right: StringName
@export var up: StringName
@export var down: StringName
@export_subgroup("Action")
@export var jump: StringName

const ORIGINAL_SCALE = Vector2(1, 1)
const JUMP_SCALE = Vector2(1.5, 1.5)

var state: PlayerState = PlayerState.GROUNDED

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
	process_input()

func _physics_process(delta):
	move_and_slide()
	if (state == PlayerState.FALLING):
		scale.x -= delta
		scale.y = scale.x
		if (scale <= ORIGINAL_SCALE):
			update_state(PlayerState.GROUNDED)
		$Sprite2D.z_index = scale.x # TODO: find a way to render overlap
