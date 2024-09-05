extends Control
@onready var margin_container = $MarginContainer as MarginContainer
@onready var margin_container_2 = $Specter2/MarginContainer2 as MarginContainer
@onready var label = $Label as Label
@onready var label_2 = $Specter2/Label2 as Label
@onready var home = $MarginContainer/VBoxContainer/HBoxContainer/Home as Button
@onready var leave = $MarginContainer/VBoxContainer/HBoxContainer/Leave as Button
@onready var no = $Specter2/MarginContainer/VBoxContainer/HBoxContainer/No as Button
@onready var yes = $Specter2/MarginContainer/VBoxContainer/HBoxContainer/Yes as Button
@onready var game_menu = preload("res://Menu/Options/are_you_sure.gd")
@onready var GAME_MENU = preload("res://Menu/Options/game_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_home_button_down():
	get_tree().change_scene_to_packed(GAME_MENU)


func _on_leave_button_down():
	margin_container.visible = false
	label.visible = false
	margin_container_2.visible = true
	label_2.visible = true
	get_tree().change_scene_to_packed(game_menu)

func _on_no_button_down():
	get_tree().change_scene_to_packed(game_menu)


func _on_yes_button_down():
	get_tree().quit()
