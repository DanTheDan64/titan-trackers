extends RigidBody3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	if Input.is_action_just_released("fire_hook"):
		$"..".change_state()
		$"../moving_physicsbody".velocity = linear_velocity
		linear_velocity = Vector3.ZERO
		global_rotation_degrees = Vector3.ZERO
