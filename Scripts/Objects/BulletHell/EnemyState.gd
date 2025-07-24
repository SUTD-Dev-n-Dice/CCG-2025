class_name EnemyState extends State

const IDLE = "Idle"
const CHARGE = "Charge"
const SHOOT = "Shoot"
const DAMAGED = "Damaged"
const MOVING = "Moving"
const FLEE = "Flee"

var enemy: Enemy

func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null, "The EnemyState state type must be used only in the BulletHell scene. It needs the owner to be a Enemy node.")
