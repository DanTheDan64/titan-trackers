extends Node

var config = GlobalConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"


func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		#Keybinding
		config.set_value("keybinding", "left", "A")
		config.set_value("keybinding", "right", "D")
		config.set_value("keybinding", "up", "W")
		config.set_value("keybinding", "down", "S")
		config.set_value("keybinding", "jump", "Space")
		config.set_value("keybinding", "fire_hook", "J")
		config.set_value("keybinding", "shoot", "K")
		config.set_value("keybinding", "escape", "Escape")
		config.set_value("keybinding", "sneak", "Shift")
		config.set_value("keybinding", "slide", "Ctrl")
		config.set_value("keybinding", "crash", "Shift")
		
		#Video
		config.set_value("video", "fullscreen", true)
		config.set_value("video", "VSyncMode", false)
		
		#Audio
		config.set_value("audio", "Master", 1.0)
		config.set_value("audio", "music", 1.0)
		config.set_value("audio", "sfx", 1.0)
		
		#crosshair
		
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
func save_video_setting(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
	
func save_audio_setting(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass






















