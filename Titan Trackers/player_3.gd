extends CharacterBody3D



enum STATES {
	MOVING,
	SLIDING,
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
var state_stats = {
	STATES.MOVING: [3, 24],
	STATES.JUMPING: [0.5, 5],
	STATES.SLIDING: [0.15, 0.3],
	STATES.GRAPPLING: [2, 0.1],
	STATES.AIRBORN: [0.1, 0.1]
}

#moving
var friction: float = state_stats[state][0]
var accell: float = state_stats[state][0]
var jump_velocity: int = 6

@onready var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
@onready var direction: Vector3 = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
@onready var direction_flat: Vector3 = (movement_orienter.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#grappling
var shoot_to = Vector3.ZERO

var held_pos: Vector3 = Vector3.ZERO
var coyote_time: float = 0.2
var grapple_range: int = 800
var pull_strength: int = 200

var can_grapple: bool = true

@onready var grapple_line = $LineRenderer3D


var grapple_data: Dictionary


#random
var highest = 0
var speed = 0

var normal_fov = 75
var wanted_fov = 0

func _ready():
	grapple_line.hide()
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
	
	#shoot ray out to see if it can grapple and where to grapple around
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(
	cam.global_position,
	cam.global_position + -cam.transform.basis.z * grapple_range)
	grapple_data = space_state.intersect_ray(query)
	
	movement(delta)
	
	#state machine
	match state:
		STATES.MOVING: moving()
		STATES.JUMPING: jumping()
		STATES.SLIDING: sliding()
		STATES.GRAPPLING: grappling(delta)
		STATES.AIRBORN: airborn()
	
	#shooting enemies
	if Input.is_action_just_pressed("shoot") and grapple_data:
		if grapple_data.collider.is_in_group("enemy"):
			grapple_data.collider.hit()
	
	#to show if the player can grapple
	if state != STATES.GRAPPLING:
		if grapple_data:
			if not grapple_data.collider.is_in_group("enemy"):
				crosshair.modulate = Color.RED
		else:
			crosshair.modulate = Color.WHITE
	
	
	#track speed of player
	speed = velocity.distance_to(Vector3.ZERO)
	
	#change fov dependant on speed
	wanted_fov = move_toward(
		wanted_fov, 
		clamp(speed - 80, 0, 10), 
		10 * delta
		)
	
	cam.set_fov(normal_fov + (wanted_fov * 3.5))
	
	#ui elements
	$"../2d/TextureProgressBar".value = move_toward(
		$"../2d/TextureProgressBar".value, speed, 100 * delta)
	
	$"../2d/TextureProgressBar/Label2".text = str(snapped(speed, 0.1))
	
	
	move_and_slide()


#state functions
func moving():
	check_jump()
	check_slide()
	check_and_start_grapple()
	
	if not is_on_floor():
		update_state(STATES.JUMPING)


func jumping():
	check_and_start_grapple()
	check_boost()
	
	if is_on_floor():
		if Input.is_action_pressed("slide"):
			update_state(STATES.SLIDING)
		else:
			update_state(STATES.MOVING)


func sliding():
	check_and_start_grapple()
	
	cam.position.y = -1
	if not is_on_floor():
		update_state(STATES.AIRBORN)
	elif Input.is_action_just_released("slide"):
		cam.position.y = -0.5
		update_state(STATES.MOVING)
	elif Input.is_action_pressed("jump"):
		velocity.y += jump_velocity
		update_state(STATES.AIRBORN)


func grappling(delta):
	check_boost()
	
	if position.distance_to(shoot_to) > 2:
		velocity += (shoot_to - position).normalized() * delta * pull_strength
	
	grapple_line.points[0] = movement_orienter.global_position
	grapple_line.points[1] = shoot_to
	
	if Input.is_action_just_released("fire_hook"):
		grapple_line.hide()
		crosshair.modulate = Color.WHITE
		if is_on_floor():
			update_state(STATES.MOVING)
		else:
			update_state(STATES.AIRBORN)
			velocity += (shoot_to - position).normalized() * pull_strength / 10


func airborn():
	check_and_start_grapple()
	check_boost()
	
	if is_on_floor():
		update_state(STATES.MOVING)



#helper scripts
func movement(delta):
	movement_orienter.rotation_degrees = Vector3(0, cam.rotation_degrees.y, 0)
	
	input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction_flat = (movement_orienter.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity += ((direction_flat * accell) - (velocity * friction)) * delta


func check_jump():
	if Input.is_action_pressed("jump"):
		velocity.y += jump_velocity
		update_state(STATES.JUMPING)
	elif not is_on_floor():
		update_state(STATES.JUMPING)


func check_slide():
	if Input.is_action_pressed("slide") and is_on_floor():
		update_state(STATES.SLIDING)


func check_and_start_grapple():
	#setting grapple around and coyote time
	if grapple_data:
		if not grapple_data.collider.is_in_group("enemy"):
			held_pos = grapple_data.position
			$grapple_coyote_time.start(coyote_time)
	
	
	#shoot grapple
	if Input.is_action_just_pressed("fire_hook"):
		if held_pos and can_grapple:
			grapple_line.points[0] = movement_orienter.global_position
			grapple_line.points[1] = shoot_to
			grapple_line.show()
			
			crosshair.modulate = Color.GREEN
			
			shoot_to = held_pos
			
			#go to grapple state
			can_grapple = false
			$grapple_cooldown.start(1)
			update_state(STATES.GRAPPLING)
			return


func check_boost():
	if Input.is_action_just_pressed("jump"):
		if direction:
			velocity += direction * 50
		else:
			velocity += -cam.transform.basis.z * 50
			
		if state == STATES.JUMPING:
			update_state(STATES.AIRBORN)
		return


func update_state(state_to):
	state = state_to
	friction = state_stats[state][0]
	accell = state_stats[state][1]
	
	match state:
		STATES.MOVING: $"../2d/Label".text = "moving"
		STATES.JUMPING: $"../2d/Label".text = "jumping"
		STATES.SLIDING: $"../2d/Label".text = "sliding"
		STATES.GRAPPLING: $"../2d/Label".text = "grappling"
		STATES.AIRBORN: $"../2d/Label".text = "airborn"


#signals
func _on_grapple_coyote_time_timeout():
	held_pos = Vector3.ZERO


func _on_grapple_cooldown_timeout():
	can_grapple = true







