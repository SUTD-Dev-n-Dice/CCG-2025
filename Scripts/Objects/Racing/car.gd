extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 300

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D
@onready var reverse_camera: Camera3D = $CameraPivot/ReverseCamera

var look_at

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("left1", "right1") * MAX_STEER, delta * 2.5)
	engine_force = Input.get_axis("left1", "right1") * ENGINE_POWER
	
	# Move and rotate camera with car
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(look_at) # Smoothen camera
	reverse_camera.look_at(look_at)
	_check_camera_switch()
	
func _check_camera_switch():
	# Check if car is moving backwards and show the relevant camera
	if linear_velocity.dot(transform.basis.z) > 0:
		camera_3d.current = true
	else:
		reverse_camera.current = true
