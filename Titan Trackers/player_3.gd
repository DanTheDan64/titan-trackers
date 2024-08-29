extends CharacterBody3D

#want to do:
#decide what states are wanted
#add states
#add helper func for non grapple states going to grapple
#
#
#

enum STATES {
	MOVING,
	SNEAKING,
	JUMPING,
	GRAPPLING,
	AIRBORN
}

var state: STATES = STATES.MOVING

var gravity: int = 30


#camera
@onready var cam: Object = $Camera3D
var sens: float = 0.2

#objects
@onready var movement_orienter: Object = $movement_orienter
@onready var retical = $UserRetical/retical

#movement
var max_speed: int = 8
var accell: int = 30
var jump_velocity: int = 6

@onready var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
@onready var direction: Vector3 = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
@onready var direction_flat: Vector3 = (movement_orienter.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#grappling
var shoot_to = Vector3.ZERO

var held_pos: Vector3 = Vector3.ZERO
var coyote_time: float = 0.2
var grapple_range: int = 800
var pull_strength: int = 150


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	retical.DOT_COLOR = Color.BLUE
	

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
	#shoot ray out to see if it can grapple and where to grapple around
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(
	cam.global_position,
	cam.global_position + -cam.transform.basis.z * grapple_range)
	var result = space_state.intersect_ray(query)
	
	
	#setting grapple around and coyote time
	if result and state == 0:
		retical.DOT_COLOR = Color.RED
		held_pos = result.position
		$grapple_coyote_time.start(coyote_time)
	
	
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
		STATES.GRAPPLING: grappling(delta)
		_: moving(delta, result)
	
	
	move_and_slide()


func moving(delta, result):
	#thing for moving
	movement_orienter.rotation_degrees = Vector3(0, cam.rotation_degrees.y, 0)
	
	#movement
	input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction_flat = (movement_orienter.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction_flat.x * max_speed, accell * delta)
	velocity.z = move_toward(velocity.z, direction_flat.z * max_speed, accell * delta)
	
	
	#shoot grapple, go to grapple state
	if Input.is_action_just_pressed("fire_hook"):
		retical.DOT_COLOR = Color.GREEN
		retical.queue_redraw()
		if held_pos:
			$grapple_coyote_time.stop()
			
			shoot_to = held_pos
			state = STATES.GRAPPLING
			return


func grappling(delta):
	velocity += (shoot_to - position).normalized() * delta * pull_strength
	
	velocity.x = move_toward(velocity.x, 0, accell * delta)
	velocity.z = move_toward(velocity.z, 0, accell * delta)
	
	if Input.is_action_just_released("fire_hook"):
		retical.DOT_COLOR = Color.WHITE
		state = STATES.MOVING


func _on_grapple_coyote_time_timeout():
	retical.DOT_COLOR = Color.WHITE
	retical.queue_redraw()
	held_pos = Vector3.ZERO










