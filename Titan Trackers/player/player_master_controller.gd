extends Marker3D

var sens = 0.2
@onready var stuff_holder = $stuff_holder

@onready var cam = $stuff_holder/Camera3D

@onready var moving_physicsbody = $moving_physicsbody
@onready var grappling_physicsbody = $grappling_physicsbody

@onready var cc = "moving"

var max_speed = 8
var accell = 30

var JUMP_velocity = 6

var gravity = 12


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if cc == "moving":
		grappling_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED
	elif cc == "grappling":
		moving_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED

func _input(event):
	#camera movement
	if event is InputEventMouseMotion:
		cam.rotation_degrees.y += -event.relative.x * sens
		cam.rotation_degrees.x += -event.relative.y * sens
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	elif InputEvent:
		if Input.is_action_pressed("escape"):
			get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#state machine
	match cc:
		"moving": moving_controller()
		"grappling": grappling_controller()


func change_state(state_to):
	if state_to == "grappling":
		#change all the vars to change state
		cc = "grappling"
		grappling_physicsbody.process_mode = Node.PROCESS_MODE_INHERIT
		moving_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED
		%PinJoint3D.set_node_b("player_2/grappling_physicsbody")
		
		#see if variables are right
		if \
		grappling_physicsbody.process_mode == Node.PROCESS_MODE_INHERIT \
		and moving_physicsbody.process_mode == Node.PROCESS_MODE_DISABLED \
		and cc == "grappling":
			print()
			print()
			print(%PinJoint3D.get_node_a())
			print(%PinJoint3D.get_node_b())
		
	elif state_to == "moving":
		#change all the vars to change state
		cc = "moving"
		grappling_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED
		moving_physicsbody.process_mode = Node.PROCESS_MODE_INHERIT
		%PinJoint3D.set_node_b("extra")


#have moving_physicsbody's siblings follow it
func moving_controller():
	stuff_holder.position = moving_physicsbody.position
	grappling_physicsbody.position = moving_physicsbody.position


#have grappling_physicsbody's siblings follow it
func grappling_controller():
	stuff_holder.position = grappling_physicsbody.position
	moving_physicsbody.position = grappling_physicsbody.position






