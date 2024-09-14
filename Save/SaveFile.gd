class_name Save_game
extends Resource

const SAVE_GAME_PATH := "res://Save/SaveFile.gd"

@export var music: Resource = preload("res://Menu/Options/Audio/music_music_slider.tscn")
@export var sfx: Resource = preload("res://Menu/Options/Audio/sfx_slider.tscn")

@export var windowmode:  Resource = preload()