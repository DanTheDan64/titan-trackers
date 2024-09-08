class_name Settings_Tab_Container
extends Control

@onready var user_retical = $UserRetical

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_crosshair_tab_button_pressed(tab):
	user_retical.visible = true
