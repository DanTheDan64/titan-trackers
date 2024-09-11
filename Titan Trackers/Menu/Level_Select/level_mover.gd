extends Marker3D

@onready var marker = $"."
@onready var cam = $Camera3D
@onready var animation_player = $"../AnimationPlayer"


var selected = global.level_on
var on = selected
var gap = []


func _input(event):
	if event is InputEvent:
		if Input.get_axis("left", "right"):
			selected += Input.get_axis("left", "right")
		selected = clamp(selected, 0, 2)
		$"../gui".get_node(str(on)).hide()
		if not animation_player.is_playing():
			run_animation()


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../gui".get_node(str(selected)).show()
	
	#for child in $"../gui".get_children():
		#if global.records[child.name.to_int()]:
			#get_node(str(child.name) + "/VBoxContainer/Panel2/Label").text = \
			#"record:" + "\n" + \
			#global.records[child.name.to_int()]
		#else:
			#get_node(str(child.name) + "/VBoxContainer/Panel2/Label").text = \
			#"record:" + "\n" + \
			#"unavailable"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_player_animation_finished(_anim_name):
	run_animation()


func run_animation():
	if selected != on:
		if selected > on:
			animation_player.play("move_between_" + str(on) + "_" + str(on + 1))
			on += 1
		if selected < on:
			animation_player.play_backwards("move_between_" + str(on - 1) + "_" + str(on))
			on -= 1
	else:
		$"../gui".get_node(str(selected)).show()


