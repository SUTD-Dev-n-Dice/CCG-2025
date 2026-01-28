extends CharacterBody3D

var speed : int = 20
var gravity : int = 20

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	var input_x = Input.get_axis("left1", "right1")
	velocity.x = input_x * speed
	velocity.y += gravity * delta

	#TODO: Add a simple movement to this character body, for left-right movement
	
	#velocity = move_and_slide()
