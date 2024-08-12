extends Marker3D


var sens = 0.2
@onready var cam = $stuff_holder/Camera3D
@onready var cc = $non_grappling_state


var max_speed = 8
var accell = 30

var JUMP_velocity = 6

var gravity = 12

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	controller()


func controller():
	$stuff_holder.position = cc.position
	$stuff_holder.position.y += 1.5







