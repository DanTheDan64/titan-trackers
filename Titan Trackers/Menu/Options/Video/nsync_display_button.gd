extends Control
@onready var check_button = $HBoxContainer/CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.VSYNC_ADAPTIVE
	else:
		DisplayServer.VSYNC_DISABLED
		
