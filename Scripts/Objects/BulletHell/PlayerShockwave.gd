extends Node2D

#region Class Preloads
const Player = preload("res://Scripts/Objects/BulletHell/Player.gd")
const Enemy = preload("res://Scripts/Objects/BulletHell/Enemy.gd")
#endregion

@export_group("Properties")
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var start_radius: float = 100
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var max_radius: float = 1000
@export var spread_duration_sec: float = 1.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var width: float = 5

var player: Player

var time_elapsed_sec: float = 0.0
var radius: float
var inner_radius: float:
	get: return max(0.0, radius - thickness)

var thickness: float:
	get: return $Line2D.width
	set(width): $Line2D.width = width

var centre: Vector2:
	get: return self.position
	set(new): self.position = new

var area: Area2D:
	get: return $Area2D

var overlapping_bodies: Array[Node2D] = []

func _update_circle_shape_radius(collision: CollisionShape2D, radius: float):
	var circle = collision.shape as CircleShape2D
	if circle != null:
		circle.radius = radius

func _update_circle():
	# calculate new radius
	var t = min(time_elapsed_sec / spread_duration_sec, 1.0)
	radius = lerp(start_radius, max_radius, t)
	
	# update collision body shape
	_update_circle_shape_radius($Area2D/CollisionOuter2D, radius)
	_update_circle_shape_radius($Area2D/CollisionInner2D, inner_radius)

	# calculate circle outline
	var num_sides = 128
	var points = PackedVector2Array()
	var angle_delta = TAU / float(num_sides)
	for i in range(num_sides + 1):
		var angle = i * angle_delta
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
	$Line2D.points = points

func _is_body_in_outline(body: Node2D):
	var dist = position.distance_to(body.position)
	return dist > inner_radius and dist <= radius

func _destroy():
	if player != null:
		player.shockwave = null
	queue_free()

func _ready():
	thickness = width
	radius = start_radius
	if player != null:
		centre = player.position
	area.body_entered.connect(func(body): overlapping_bodies.append(body))
	area.body_exited.connect(func(body): overlapping_bodies.erase(body))

func _physics_process(delta):
	if time_elapsed_sec >= spread_duration_sec:
		_destroy()

	time_elapsed_sec += delta
	_update_circle()
	for body in area.get_overlapping_bodies():
		if not _is_body_in_outline(body):
			continue
		if body.is_in_group("Enemy"):
			# we may want a generic take damage if not everything is bullet
			print("[Debug] Enemy Detected")
			body.bulletDamaged()
		if body is Player:
			body.take_damage(1.0)
