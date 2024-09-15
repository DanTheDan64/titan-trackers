extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1280x720" : Vector2i(1280, 720),
	"1366x768" : Vector2i(1366, 768),
	"1600x900" : Vector2i(1600, 900),
	"1920x1080" : Vector2i(1920, 1080),
	"1920x1200" : Vector2i(1920, 1200),
	"2560x1440" : Vector2i(2560, 1440),
	"2560x1600" : Vector2i(2560, 1600),
	"3840x2160" : Vector2i(3840, 2160),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_item()


func add_resolution_item():
	for I in RESOLUTION_DICTIONARY:
		option_button.add_item(I)
		
func on_resolution_selected(index : int):
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
