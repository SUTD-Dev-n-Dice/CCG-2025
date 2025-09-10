extends Node2D

#region Class Preloads
const Player = preload("res://Scripts/Objects/BulletHell/Player.gd")
const Enemy = preload("res://Scripts/Objects/BulletHell/Enemy.gd")
#endregion

@export_group("Properties")
@export var active_time_sec: float = 2
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var width: float = 10

var player: Player
var tracker: Player.SharedState

var thickness: float:
	get: return $Line2D.width
	set(width): $Line2D.width = width

var start: Vector2:
	get: return $Line2D.points[0]
	set(start): $Line2D.points[0] = start

var end: Vector2:
	get: return $Line2D.points[1]
	set(end): $Line2D.points[1] = end

func _update_polygon():
	# update line points
	start = player.position
	end = player.other.position

	# calculate collision body
	var p1 = start
	var p2 = end
	var dir = (p2 - p1).normalized()
	var normal = Vector2(-dir.y, dir.x)
	var width = thickness / 2
	$Area2D/CollisionPolygon2D.polygon = [
		p1 + normal * width,
		p2 + normal * width,
		p1 - normal * width,
		p1 - normal * width,
	];

func _destroy() -> void:
	if tracker != null:
		tracker.spike = null
	queue_free()

func _ready() -> void:
	thickness = width;
	var t = get_tree().create_timer(active_time_sec)
	t.timeout.connect(_destroy)

func _physics_process(delta: float) -> void:
	if player == null or player.other == null:
		_destroy()

	_update_polygon()
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			# we may want a generic take damage if not everything is bullet
			body.bulletDamaged()
