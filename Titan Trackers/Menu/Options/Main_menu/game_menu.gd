extends Control

@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit
@onready var option = $MarginContainer/HBoxContainer/VBoxContainer/Option
@onready var resume = $MarginContainer/HBoxContainer/VBoxContainer/Resume
@onready var margin_container = $MarginContainer
@onready var options = preload("res://Menu/Options/Main_menu/options_menu.tscn" )
@onready var sure = preload("res://Menu/Options/Pause/are_you_sure.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_resume_button_down():
	margin_container.visible = false

func _on_option_button_down():
	get_tree().change_scene_to_packed(options)

func _on_exit_button_down():
	get_tree().change_scene_to_packed(sure)
