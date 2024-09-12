extends CharacterBody3D


enum STATES {
	MOVING,
	JUMPING,
	SLIDING,
	CRASHING,
	GRAPPLING,
	AIRBORN
}

var state: STATES = STATES.MOVING


#camera
@onready var cam: Object = $Camera3D
var sens: float = 0.2

#objects
@onready var movement_orienter: Object = $movement_orienter

@onready var crosshair: Object = $"gui/Sprite2D"
@onready var state_text_display: Object = $gui/state_display
@onready var spedometer: Object = $"gui/spedometer"
@onready var speed_text_display: Object = $"gui/spedometer/speed_display"
@onready var stopwatch = $gui/stopwatch
@onready var grapple_cooldown_display = $gui/grapple_cooldown_display

#state data
var state_stats: Dictionary = {
	STATES.MOVING: [3, 24],
	STATES.JUMPING: [0.5, 5],
	STATES.SLIDING: [0.15, 0.3],
	STATES.CRASHING: [10, 0],
	STATES.GRAPPLING: [2, 0.1],
	STATES.AIRBORN: [0.1, 0.1]
}

#general movement
var friction: float = state_stats[state][0]
var accell: float = state_stats[state][0]
var jump_velocity: int = 6
var gravity: int = 12

@onready var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
@onready var direction: Vector3 = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
@onready var direction_flat: Vector3 = (movement_orienter.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#grappling
var shoot_to = Vector3.ZERO

var held_pos: Vector3 = Vector3.ZERO
var coyote_time: float = 0.2
var grapple_range: int = 300
var pull_strength: int = 200
var grapple_cooldown_length: int = 1

var can_grapple: bool = true

@onready var grapple_line: Object = $LineRenderer3D


var grapple_data: Dictionary


#random
var speed: float = 0.0

var normal_fov: float = 75.0
var wanted_fov: float = 0.0

var boosts_left = 3

var kills_needed: int = 0

var time: float = 0.0

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
		STATES.CRASHING: crashing()
		STATES.GRAPPLING: grappling(delta)
		STATES.AIRBORN: airborn()
	
	#shooting enemies
	if Input.is_action_just_pressed("shoot") and grapple_data:
		if grapple_data.collider.is_in_group("enemy"):
			grapple_data.collider.hit()
			kills_needed -= 1
			if kills_needed == 0:
				$gui/AnimationPlayer.play("stage_cleared")
	
	
	#show what the grapple ray hit
	if grapple_data:
		if grapple_data.collider.is_in_group("enemy"):
			crosshair.modulate = Color.GREEN
		else:
			crosshair.modulate = Color.RED
	else:
		crosshair.modulate = Color.WHITE
	
	
	#track speed of player
	speed = velocity.distance_to(Vector3.ZERO)
	
	if speed > 350:
		velocity = velocity.normalized() * 350
		speed = velocity.distance_to(Vector3.ZERO)
	
	
	#change fov dependant on speed
	wanted_fov = move_toward(
		wanted_fov, 
		clamp(speed - 60, 0, 10), 
		10 * delta
		)
	
	cam.set_fov(normal_fov + (wanted_fov * 3.5))
	
	#ui elements
	spedometer.value = move_toward(
		spedometer.value, speed, 100 * delta)
	
	speed_text_display.text = str(snapped(speed, 0.1))
	
	
	grapple_cooldown_display.value = 100 - $grapple_cooldown.time_left * 100
	
	grapple_cooldown_display.modulate = Color(
		$grapple_cooldown.time_left,
		1 - $grapple_cooldown.time_left,
		0,
		1.0
	)
	
	time += delta
	$gui/stopwatch.text = str(snapped(time, 0.01))
	
	move_and_slide()


#state functions
func moving():
	check_jump()
	check_slide_and_crash()
	check_and_start_grapple()
	
	if not is_on_floor():
		update_state(STATES.JUMPING)


func jumping():
	check_and_start_grapple()
	check_boost()
	
	if is_on_floor():
		if Input.is_action_pressed("slide"):
			update_state(STATES.SLIDING)
		elif Input.is_action_pressed("crash"):
			update_state(STATES.CRASHING)
		else:
			update_state(STATES.MOVING)


func sliding():
	check_and_start_grapple()
	
	cam.position.y = -1
	if not is_on_floor():
		update_state(STATES.AIRBORN)
	elif Input.is_action_pressed("jump"):
		velocity.y += jump_velocity
		update_state(STATES.AIRBORN)
	elif Input.is_action_just_released("slide"):
		cam.position.y = -0.5
		update_state(STATES.MOVING)
	elif Input.is_action_just_pressed("crash"):
		cam.position.y = -0.5
		update_state(STATES.CRASHING)


func crashing():
	check_and_start_grapple()
	
	cam.position.y = -1
	if not is_on_floor():
		update_state(STATES.AIRBORN)
	elif Input.is_action_pressed("jump"):
		velocity.y += jump_velocity
		update_state(STATES.AIRBORN)
	elif Input.is_action_just_released("crash"):
		cam.position.y = -0.5
		update_state(STATES.MOVING)
	elif Input.is_action_just_pressed("slide"):
		cam.position.y = -0.5
		update_state(STATES.SLIDING)


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
		if Input.is_action_just_released("slide"):
			update_state(STATES.SLIDING)
		elif Input.is_action_pressed("crash"):
			update_state(STATES.CRASHING)
		else:
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


func check_slide_and_crash():
	if is_on_floor():
		if Input.is_action_pressed("slide"):
			update_state(STATES.SLIDING)
		elif Input.is_action_pressed("crash"):
			update_state(STATES.CRASHING)


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
			
			
			shoot_to = held_pos
			
			#go to grapple state
			can_grapple = false
			$grapple_cooldown.start(grapple_cooldown_length)
			update_state(STATES.GRAPPLING)
			return


func check_boost():
	if Input.is_action_just_pressed("jump") and boosts_left:
		
		#fancy code toshow the amount of boost charges left
		$gui/boost_charges.get_node(str(boosts_left)).hide()
		boosts_left -= 1
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
		STATES.MOVING: state_text_display.text = "moving"
		STATES.JUMPING: state_text_display.text = "jumping"
		STATES.SLIDING: state_text_display.text = "sliding"
		STATES.CRASHING: state_text_display.text = "crashing"
		STATES.GRAPPLING: state_text_display.text = "grappling"
		STATES.AIRBORN: state_text_display.text = "airborn"


func end_level():
	var record = global.records[get_parent_node_3d().name.to_int()]
	var new_time = snapped(time, 0.001)
	
	if new_time < record or record == 0:
		global.records[get_parent_node_3d().name.to_int()] = new_time
	
	global.level_on = get_parent_node_3d().name.to_int()
	get_tree().call_deferred("change_scene_to_file", \
	"res://Menu/Main/Main_Menu.tscn")


#signals
func _on_grapple_coyote_time_timeout():
	held_pos = Vector3.ZERO


func _on_grapple_cooldown_timeout():
	can_grapple = true







