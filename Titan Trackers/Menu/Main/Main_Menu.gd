class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var start_level = preload("res://test_scene.tscn") 


func _ready():
	pass

func _on_start_button_button_down():
	get_tree().change_scene_to_packed(start_level)

func _on_options_button_button_down():
	margin_container.visible = false
	options_menu.visible = true
	options_menu.set_process(true)

func _on_exit_button_button_down():
	get_tree().quit()

func _on_options_menu_exit_options_menu():
	margin_container.visible = true
	options_menu.visible = false
	
