extends CharacterBody3D
var target_velocity = Vector3.ZERO
var speed = 10

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
		
	if Input.is_action_pressed("left"):
		direction.x -= 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	velocity = target_velocity
	move_and_slide()
