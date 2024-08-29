extends CharacterBody3D



enum STATES {
	MOVING,
	SNEAKING,
	JUMPING,
	GRAPPLING,
	AIRBORN
}

var state: STATES = STATES.MOVING

var gravity: int = 12


#camera
@onready var cam: Object = $Camera3D
var sens: float = 0.2

#objects
@onready var crosshair: Object = $"../2d/Sprite2D"
@onready var movement_orienter: Object = $movement_orienter

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

var result: Dictionary


var state_stats = {
	STATES.MOVING: [8, 50],
	STATES.JUMPING: [10, 20],
	STATES.SNEAKING: [5, 400],
	STATES.GRAPPLING: [0, 40],
	STATES.AIRBORN: [12, 30]
}

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
	
	movement(delta)
	
	match state:
		STATES.MOVING: moving(delta)
		STATES.JUMPING: jumping(delta)
		STATES.SNEAKING: sneaking(delta)
		STATES.GRAPPLING: grappling(delta)
		STATES.AIRBORN: airborn(delta)
	
	show_state()
	
	move_and_slide()


#state functions
func moving(delta):
	check_jump()
	check_sneak()
	check_and_start_grapple()
	check_boost(delta)


func jumping(delta):
	check_sneak()
	check_and_start_grapple()
	check_boost(delta)
	
	if is_on_floor():
		state = STATES.MOVING


func sneaking(delta):
	check_jump()
	check_and_start_grapple()
	check_boost(delta)
	
	if Input.is_action_just_released("sneak"):
		if is_on_floor():
			state = STATES.MOVING
		else:
			state = STATES.JUMPING


func grappling(delta):
	check_boost(delta)
	
	velocity += (shoot_to - position).normalized() * delta * pull_strength
	
	
	if Input.is_action_just_released("fire_hook"):
		crosshair.modulate = Color.WHITE
		state = STATES.AIRBORN
		update_state()


func airborn(delta):
	check_and_start_grapple()
	check_boost(delta)
	
	if is_on_floor():
		state = STATES.MOVING



#helper scripts
func movement(delta):
	movement_orienter.rotation_degrees = Vector3(0, cam.rotation_degrees.y, 0)
	
	input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction_flat = (movement_orienter.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction_flat.x * max_speed, accell * delta)
	velocity.z = move_toward(velocity.z, direction_flat.z * max_speed, accell * delta)


func check_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		state = STATES.JUMPING
		update_state()


func check_sneak():
	if Input.is_action_just_pressed("sneak"):
		state = STATES.SNEAKING
		update_state()


func check_and_start_grapple():
	#shoot ray out to see if it can grapple and where to grapple around
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(
	cam.global_position,
	cam.global_position + -cam.transform.basis.z * grapple_range)
	result = space_state.intersect_ray(query)
	
	
	#setting grapple around and coyote time
	if result:
		held_pos = result.position
		$grapple_coyote_time.start(coyote_time)
	
	
	#shoot grapple
	if Input.is_action_just_pressed("fire_hook"):
		if held_pos:
			#go to grapple state
			shoot_to = held_pos
			state = STATES.GRAPPLING
			update_state()
			return


func check_boost(delta):
	if Input.is_action_just_pressed("jump"):
			if not is_on_floor():
				if direction:
					velocity += direction * 250
				else:
					velocity += -cam.transform.basis.z * 250



func update_state():
	max_speed = state_stats[state][0]
	accell = state_stats[state][1]


func show_state():
	match state:
		STATES.MOVING: $"../2d/Label".text = "moving"
		STATES.JUMPING: $"../2d/Label".text = "jumping"
		STATES.SNEAKING: $"../2d/Label".text = "sneaking"
		STATES.GRAPPLING: $"../2d/Label".text = "grappling"
		STATES.AIRBORN: $"../2d/Label".text = "airborn"

#signals
func _on_grapple_coyote_time_timeout():
	held_pos = Vector3.ZERO









