extends CharacterBody3D

#pause input check
var pause_input = false

# How fast the player moves in meters per second.
var speed = 2
# The downward acceleration when in the air, in meters per second squared.
var fall_acceleration = 58
var jump_impulse = 20

#backstep shit
var back_on = false
var dash_on = false

var target_velocity = Vector3.ZERO
@onready var back_timer = $backtimer
@onready var back_limiter = $backlimit
@onready var dash_timer = $dashtimer

func _input(event):
	if event.is_action_pressed("left2"):
		if scale.x == -1:
			if not back_timer.is_stopped():
				back_on = true
				pause_input = true
				back_timer.stop()
				back_limiter.start()
		
	if event.is_action_pressed("right2"):
		if scale.x == 1:
			if not back_timer.is_stopped():
				back_on = true
				pause_input = true
				back_timer.stop()
				back_limiter.start()
	if event.is_action_pressed("right2"):
		if scale.x == -1:
			if not dash_timer.is_stopped():
				dash_on = true

	if event.is_action_pressed("left2"):
		if scale.x == 1:
			if not dash_timer.is_stopped():
				dash_on = true

	if Input.is_action_just_released("right2"):
		dash_on = false
	
	if Input.is_action_just_released("left2"):
		dash_on = false

func move_character(direction: Vector3, speed: float):
	velocity = direction * speed
	move_and_slide()

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	
	if back_on:
		target_velocity.x = 18 * scale.x
		velocity = target_velocity
		move_and_slide()
	else:
		# We check for each move input and update the direction accordingly.
		if not pause_input and Input.is_action_pressed("right2"):
			direction.x += 1
			if scale.x == -1:
				dash_timer.start()
			if scale.x == 1:
				back_timer.start()
				
		if not pause_input and Input.is_action_pressed("left2"):
			direction.x -= 1
			if scale.x == -1:
				back_timer.start()
			if scale.x == 1:
				dash_timer.start()
	if dash_on:
		speed = 14
	else:
		speed = 5

	#if back_timer.get_time_left() > 0:
		#print("back timer:", back_timer.get_time_left())
		
	#if dash_timer.get_time_left() > 0:
		#print("dash timer:", dash_timer.get_time_left())
	
	if back_limiter.is_stopped():
		back_on = false
		pause_input = false

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	# Ground Velocity
	target_velocity.x = direction.x * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("up2"):
		target_velocity.y = jump_impulse

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
