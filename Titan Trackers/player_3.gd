extends CharacterBody3D

#want to do:
#decide what states are wanted
#add states
#add helper func for non grapple states going to grapple
#
#
#


var gravity = 50

var state = "moving"
var shoot_to = Vector3.ZERO

#camera
@onready var cam = $Camera3D
var sens = 0.2

#movement
var max_speed = 8
var accell = 30
var jump_velocity = 6

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
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(
	cam.global_position,
	cam.global_position + -cam.transform.basis.z * 500)
	var result = space_state.intersect_ray(query)
	
	if result: $"../2d/Sprite2D".modulate = Color.RED
	else: $"../2d/Sprite2D".modulate = Color.WHITE
	
	#gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		accell = 40
	else:
		accell = 90
	
	
	#jump/boost
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
	
	match state:
		"grappling": grappling(delta)
		_: moving(delta, result)
		
	
	$"../2d/Label".text = state
	
	move_and_slide()


func moving(delta, result):
	#thing for moving
	$Marker3D.rotation_degrees = Vector3(0, cam.rotation_degrees.y, 0)
	
	#movement
	input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction_flat = ($Marker3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction_flat.x * max_speed, accell * delta)
	velocity.z = move_toward(velocity.z, direction_flat.z * max_speed, accell * delta)
	
	
	#shoot grapple, go to grapple state
	if Input.is_action_just_pressed("fire_hook"):
		
		if not result.is_empty():
			shoot_to = result.position
			state = "grappling"
			return


func grappling(delta):
	velocity += (shoot_to - position).normalized() * delta * 150
	
	velocity.x = move_toward(velocity.x, 0, accell * delta)
	velocity.z = move_toward(velocity.z, 0, accell * delta)
	
	if Input.is_action_just_released("fire_hook"):
		state = "moving"




