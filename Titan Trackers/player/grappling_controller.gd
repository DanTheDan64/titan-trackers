extends RigidBody3D

@onready var cam = $"../stuff_holder/Camera3D"
var gravity = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	linear_velocity.y -= gravity * delta
	
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#if Input.is_action_just_released("fire_hook"):
	#	$"../moving_physicsbody".velocity = linear_velocity
	#	linear_velocity = Vector3.ZERO
	#	global_rotation_degrees = Vector3.ZERO
	#	$"..".change_state()
	
	#angular_velocity = Vector3.ZERO
	if Input.is_action_pressed("shoot"):
		if direction:
			linear_velocity += direction
		else:
			linear_velocity += -$"../stuff_holder/Camera3D".transform.basis.z



