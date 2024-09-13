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
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text =  "%s" % action_keycode

<<<<<<< HEAD

func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
		
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
			
		
		set_key_text()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_key_text()
	set_action_name()
=======
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass








>>>>>>> 6ee863e1ccd91c54bbdd33f0c1122c8d2fda7dab








