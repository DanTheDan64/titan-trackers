extends Control
@onready var h_slider = $HBoxContainer/HSlider
@onready var world_environment = $WorldEnvironment
@onready var enviroment = "res://Menu/Options/world_environment.tscn::Environment_1dbcs"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_h_slider_value_changed(value):
	world_environment.adjusment_brightness = value
