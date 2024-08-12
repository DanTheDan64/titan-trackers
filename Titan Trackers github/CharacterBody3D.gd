extends CharacterBody3D


var max_speed = 8
var accell = 30

var JUMP_VELOCITY = 6

var gravity = 12

@onready var cam = $"../stuff_holder/Camera3D"

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * max_speed, accell * delta)
	velocity.z = move_toward(velocity.z, direction.z * max_speed, accell * delta)
	
	
	move_and_slide()




