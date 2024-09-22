extends Control
@onready var margin_container = $MarginContainer as MarginContainer
@onready var margin_container_2 = $MarginContainer2 as MarginContainer
@onready var label = $Label as Label
@onready var label_2 = $Label2 as Label
@onready var home = $MarginContainer/VBoxContainer/HBoxContainer/home as Button
@onready var leave = $MarginContainer/VBoxContainer/HBoxContainer/leave as Button
@onready var no = $MarginContainer2/VBoxContainer/HBoxContainer/no as Button
@onready var yes = $MarginContainer2/VBoxContainer/HBoxContainer/yes as Button
@onready var game_menu = "res://Menu/Options/Pause/are_you_sure.gd"
@onready var start_level = "res://levels/test_scene.tscn"
@onready var MAIN_MENU = "res://Menu/Main/Main_Menu.tscn"

# Called when the node enters the scene tree  the first time.
func _ready():
	pass


func _on_home_button_down():
	get_tree().change_scene_to_file(MAIN_MENU)


func _on_leave_button_down():
	margin_container.visible = false
	label.visible = false
	margin_container_2.visible = true
	label_2.visible = true
	get_tree().change_scene_to_file(game_menu)

func _on_no_button_down():
	get_tree().change_scene_to_file(game_menu)


func _on_yes_button_down():
	get_tree().quit()
