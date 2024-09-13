class_name	Save_game
extends Resource

const SAVE_GAME_PATH := "res://savegame.tres"

@export var music: Resource = preload("res://Menu/Options/Audio/music_music_slider.tscn")
@export var sfx: Resource = preload("res://Menu/Options/Audio/sfx_slider.tscn")

@export var windowmode:  Resource = preload("res://Menu/Options/Video/window_mode_button.tscn")
@export var vsync:  Resource = preload("res://Menu/Options/Video/nsync_display_button.tscn")
@export var reselution:  Resource = preload("res://Menu/Options/Video/resolution_mode_button.tscn")

@export var keybind:  Resource = preload("res://Menu/Options/KeyBind/hotkey_rebind_button.tscn")

func  write_savegame():
	ResourceSaver.save( self, SAVE_GAME_PATH)
	
static func load_savegame():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
	


