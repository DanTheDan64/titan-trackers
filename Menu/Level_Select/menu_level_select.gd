extends Node3D

const MAIN_MENU = "res://Menu/Main/Main_Menu.tscn"
const TEST_SCENE = "res://levels/test_scene.tscn"
const _1 = "res://levels/1.tscn"
const _2 = "res://levels/2.tscn"	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_0_pressed():
	pass


func _on_button_1_pressed():
	get_tree().change_scene_to_file(_1)


func _on_button_2_pressed():
	get_tree().change_scene_to_file(_2)


func _on_back_button_down():
	get_tree().change_scene_to_file(MAIN_MENU)


func _on_button_3_pressed():
	pass # Replace with function body.

func _on_button_4_pressed():
	pass # Replace with function body.
