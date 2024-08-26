extends CharacterBody3D


var max_speed = 8
var accell = 30
var jump_velocity = 6

var gravity = 12

var state = "moving"
var shoot_to = Vector3.ZERO

@onready var cam = $Camera3D
var sens = 0.2

@onready var input_dir = Input.get_vector("left", "right", "up", "down")
@onready var direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
@onready var direction_flat = ($Marker3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


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
		elif Input.is_action_just_pressed("jump"):
			if not is_on_floor():
				if direction:
					velocity += direction * 250
				else:
					velocity += -cam.transform.basis.z * 250


func _physics_process(delta):
	#gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		accell = 30
	else:
		accell = 90
	
	input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction_flat = ($Marker3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#jump/boost
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
	
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
		-cam.transform.basis.z * 4000)
		var result = space_state.intersect_ray(query)
		
		if not result.is_empty():
			shoot_to = result.position
			state = "grappling"
			var aa = preload("res://erth.tscn").instantiate()
			aa.position = result.position
			get_parent().add_child(aa)
			return


func grappling(delta):
	velocity += (shoot_to - position).normalized() * delta * 150
	if Input.is_action_just_released("fire_hook"):
		state = "moving"






