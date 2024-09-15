class_name Settings_Tab_Container
extends Control

@onready var general = $TabContainer/General
@onready var video = $TabContainer/Video
@onready var key_bind = $"TabContainer/Key Bind"
@onready var crosshair = $TabContainer/Crosshair
@onready var audio = $TabContainer/Audio
@onready var user_retical = $TabContainer/Crosshair/UserRetical

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_general_tab_button_pressed(_tab):
	general.visible = true
	video.visible = false
	key_bind.visible = false
	crosshair.visible = false
	audio.visible = false
	user_retical.visible = 0

func _on_video_tab_button_pressed(_tab):
	general.visible = false
	video.visible = true
	key_bind.visible = false
	crosshair.visible = false
	audio.visible = false
	user_retical.visible = 0

func _on_key_bind_tab_button_pressed(_tab):
	general.visible = false
	video.visible = false
	key_bind.visible = true
	crosshair.visible = false
	audio.visible = false
	user_retical.visible = 0

func _on_crosshair_tab_button_pressed(_tab):
	general.visible = false
	video.visible = false
	key_bind.visible = false
	crosshair.visible = true
	audio.visible = false
	user_retical.visible = 1

func _on_audio_tab_button_pressed(_tab):
	general.visible = false
	video.visible = false
	key_bind.visible = false
	crosshair.visible = false
	audio.visible = true
	user_retical.visible = 0
