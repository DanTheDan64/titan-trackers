class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button


@export var action_name : String = "left"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(false) #if it were to be true any inputs that aren't being handled will get picked up
	#were as if it were to be flase it would just ignore them
	#wwwwwwwwwwwwwwwwset_physics_process(true)
	set_action_name()
	set_key_text()
	
	
func set_action_name():
	label.text = "Unassigned"
	
	match action_name:
		"left":
			label.text= "Move Left"
			
		"right":
			label.text= "Move Right"
			
		"up":
			label.text= "Move up"
			
		"down":
			label.text= "Move down"
			
		"jump":
			label.text= "Jump"
			
		"sneak":
			label.text= "Crouch"
			
		"fire_hook":
			label.text= "Hook"
			
		"shoot":
			label.text= "Fire"
			
		"escape":
			label.text= "Escape"
			

func set_key_text():
	var action_events = InputMap.action_get_events(action_name)
	print(action_events)
	print("hi")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
















