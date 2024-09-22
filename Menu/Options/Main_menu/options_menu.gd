class_name OptionsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button

@onready var game_menu = "res://Menu/Options/Main_menu/game_menu.tscn"

signal exit_options_menu

func _ready():
	exit_button.button_down.connect(_on_exit_button_pressed)
	set_process(false)#this is there because some times even if you exit this scene, the buttons are still clickable(Btw process means if it's running thr code)
	#var yes = get_tree().current_scene


func _on_exit_button_pressed():
	exit_options_menu.emit()
	exit_options_menu
	set_process(false)
