extends Marker3D


var sens = 0.2
@onready var stuff_holder = $stuff_holder

@onready var cam = $stuff_holder/Camera3D

@onready var moving_physicsbody = $moving_physicsbody
@onready var grappling_physicsbody = $grappling_physicsbody

@onready var cc = moving_physicsbody

var max_speed = 8
var accell = 30

var JUMP_velocity = 6

var gravity = 12

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	grappling_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED

func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.y += -event.relative.x * sens
		cam.rotation_degrees.x += -event.relative.y * sens
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	elif InputEvent:
		if Input.is_action_pressed("escape"):
			get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match cc:
		moving_physicsbody: moving_controller()
		grappling_physicsbody: grappling_controller()


func change_state():
	if cc == moving_physicsbody:
		cc = grappling_physicsbody
		grappling_physicsbody.process_mode = Node.PROCESS_MODE_INHERIT
		moving_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED
		
	elif cc == grappling_physicsbody:
		cc = moving_physicsbody
		grappling_physicsbody.process_mode = Node.PROCESS_MODE_DISABLED
		moving_physicsbody.process_mode = Node.PROCESS_MODE_INHERIT
		


func moving_controller():
	stuff_holder.position = moving_physicsbody.position
	grappling_physicsbody.position = moving_physicsbody.position

func grappling_controller():
	stuff_holder.position = grappling_physicsbody.position
	moving_physicsbody.position = grappling_physicsbody.position





