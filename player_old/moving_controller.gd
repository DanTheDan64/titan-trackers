extends CharacterBody3D


var max_speed = 8
var accell = 30

var JUMP_VELOCITY = 6

var gravity = 12

@onready var cam = $"../stuff_holder/Camera3D"

func _physics_process(delta):
	#gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#movement
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * max_speed, accell * delta)
	velocity.z = move_toward(velocity.z, direction.z * max_speed, accell * delta)
	
	#boost the player forwards
	if Input.is_action_pressed("shoot"):
		if direction:
			velocity += direction
		else:
			velocity += -cam.transform.basis.z
	
	#shoot grapple, go to grapple state
	if Input.is_action_just_pressed("fire_hook"):
		print("1")
		var space_state = get_world_3d().direct_space_state
		
		#shoot raycast forwards and find point hit
		var query = PhysicsRayQueryParameters3D.create(
		cam.global_position,
		-cam.transform.basis.z * 100000000)
		var result = space_state.intersect_ray(query)
		
		#set pinjoint position, transfer velocity and trigger change state func
		if not result.is_empty():
			$"../../swing_around".position = result.position
			%PinJoint3D.position = result.position
			$"../grappling_physicsbody".linear_velocity = velocity
			velocity = Vector3.ZERO
			$"..".change_state("grappling")
			return
	
	
	move_and_slide()




