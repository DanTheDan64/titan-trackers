extends Control

@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit
@onready var option = $MarginContainer/HBoxContainer/VBoxContainer/Option
@onready var resume = $MarginContainer/HBoxContainer/VBoxContainer/Resume
@onready var margin_container = $MarginContainer
@onready var OPTIONS_MENU = "res://Menu/Options/Main_menu/options_menu.tscn"
@onready var SETTINGS_TAB_CONTAINER = "res://Menu/Options/Main_menu/settings_tab_container.tscn"
@onready var GAME_MENU = "res://Menu/Options/Main_menu/game_menu.tscn"
@onready var sure = "res://Menu/Options/Pause/are_you_sure.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_resume_button_down():
	margin_container.visible = false

func _on_option_button_down():
	get_tree().change_scene_to_file(OPTIONS_MENU)

func _on_exit_button_down():
	get_tree().change_scene_to_file(sure)
