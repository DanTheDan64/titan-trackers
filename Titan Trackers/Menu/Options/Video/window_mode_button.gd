extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton
const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	add_window_items()
	option_button.item_selected.connect(on_window_mode_selected)
	
func add_window_items():
	for I in WINDOW_MODE_ARRAY:#i is just window mode
		option_button.add_item(I)

func on_window_mode_selected(index : int):
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)#this changes the display mode to fullscreen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)#this makes your window to either have or not have a border
		1:#Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)#this changes the display mode to windowed
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:#Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:#Borderless Full-Screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

