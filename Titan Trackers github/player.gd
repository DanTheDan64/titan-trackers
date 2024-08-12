extends CharacterBody3D


var sens = 0.2
var gravity = 12

var old_state = "grappling"
var state = "grappling"

var states: Dictionary = {
	"walking": [8, 30],
	"sneaking": [4, 20],
	"in_air": [10, 2],
	"wall running": [],
	"grappling": [],
	"damaged": []
}

var max_speed = states["walking"][0]
var accell = states["walking"][1]
const JUMP_VELOCITY = 6

@onready var cam = $"../cam"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.y += -event.relative.x * sens
		cam.rotation_degrees.x += -event.relative.y * sens
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	elif InputEvent:
		if Input.is_action_pressed("escape"):
			get_tree().quit()


func _physics_process(delta):
	
	
	if state != "grappling":
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		velocity.x = move_toward(velocity.x, direction.x * max_speed, accell * delta)
		velocity.z = move_toward(velocity.z, direction.z * max_speed, accell * delta)
	else:
		$"..".global_rotation_degrees = Vector3.ZERO
		position = Vector3.ZERO
	if Input.is_action_pressed("shoot"):
		$"../..".linear_velocity += -$"../cam".transform.basis.z
	
	match state:
		"walking": walking(delta)
		"sneaking": sneaking(delta)
		"in_air": in_air(delta)
		"wall running": pass
		"grappling": pass
		"damaged": pass
	
	if old_state != state:
		max_speed = states[state][0]
		accell = states[state][1]
		old_state = state
	
	#print($"..".global_position)
	
	#print(Vector3.ZERO.distance_to(\
	#Vector3(velocity.x, 0, velocity.z)))
	move_and_slide()

func walking(delta):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state = "in_air"
	
	
	if Input.is_action_just_pressed("sneak"):
		state = "sneaking"
	elif Input.is_action_just_pressed("fire_hook"):
		state = "grappling"


func sneaking(delta):
	if Input.is_action_just_released("sneak"):
		state = "walking"


func in_air(delta):
	# Handle jump.
	if is_on_floor():
		gravity = 12
		state = "walking"
		return
	
	if Input.is_action_just_released("jump") or velocity.y <= 20:
		gravity = 18




