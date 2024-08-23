extends CharacterBody3D


var max_speed = 8
var accell = 30
var jump_velocity = 6

var gravity = 12

var state = "moving"
var shoot_to = Vector3.ZERO

@onready var cam = $Camera3D
var sens = 0.2


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	#camera movement
	if event is InputEventMouseMotion:
		cam.rotation_degrees.y += -event.relative.x * sens
		cam.rotation_degrees.x += -event.relative.y * sens
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	elif InputEvent:
		if Input.is_action_pressed("escape"):
			get_tree().quit()


func _physics_process(delta):
	#gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		accell = 30
	else:
		accell = 90
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction_flat = ($Marker3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#jump/boost
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		else:
			if direction:
				velocity += direction * 1000
			else:
				velocity += -cam.transform.basis.z * 1000
	
	match state:
		"grappling": grappling(delta)
		_: moving(delta, direction, direction_flat)
		
	
	$"../2d/Label".text = state
	
	move_and_slide()


func moving(delta, direction, direction_flat):
	#thing for moving
	$Marker3D.rotation_degrees = Vector3(0, cam.rotation_degrees.y, 0)
	
	#movement
	
	velocity.x = move_toward(velocity.x, direction_flat.x * max_speed, accell * delta)
	velocity.z = move_toward(velocity.z, direction_flat.z * max_speed, accell * delta)
	
	
	
	#shoot grapple, go to grapple state
	if Input.is_action_just_pressed("fire_hook"):
		var space_state = get_world_3d().direct_space_state
		
		
		var query = PhysicsRayQueryParameters3D.create(
		cam.global_position,
		-cam.transform.basis.z * 10000)
		var result = space_state.intersect_ray(query)
		
		if not result.is_empty():
			shoot_to = result.position
			gravity = 30
			state = "grappling"
			return


func grappling(delta):
	velocity += (shoot_to - position).normalized() * delta * 250
	if Input.is_action_just_released("fire_hook"):
		gravity = 12
		state = "moving"






