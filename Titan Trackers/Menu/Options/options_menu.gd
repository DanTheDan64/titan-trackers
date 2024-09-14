class_name OptionsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button


signal exit_options_menu

func _ready():
	exit_button.button_down.connect(_on_exit_button_button_down)
	set_process(false)#this is there because some times even if you exit this scene, the buttons are still clickable(Btw process means if it's running thr code)



func _on_exit_button_button_down():
	exit_options_menu.emit()
	set_process(false)
