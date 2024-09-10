extends Node3D

const MAIN_MENU = "res://Menu/Main/Main_Menu.tscn"
const TEST_SCENE = "res://levels/test_scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file(MAIN_MENU)


func _on_button_0_pressed():
	get_tree().change_scene_to_file(TEST_SCENE)


func _on_button_1_pressed():
	pass # Replace with function body.


func _on_button_2_pressed():
	pass # Replace with function body.
