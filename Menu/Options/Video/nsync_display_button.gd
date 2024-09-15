extends Control
@onready var check_button = $HBoxContainer/CheckButton


func _on_check_button_toggled(toggled_on):
	if toggled_on:
		#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		#return DisplayServer.VSYNC_ENABLED
		DisplayServer.VSYNC_ENABLED
	else:
		#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#return DisplayServer.VSYNC_DISABLED
		DisplayServer.VSYNC_DISABLED
