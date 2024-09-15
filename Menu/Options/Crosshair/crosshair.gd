class_name Crosshair
extends TabBar

@export var DOT_RADIUS :float = 1.0
@export var DOT_COLOR : Color = Color.WHITE
@onready var crosshair = $"." as TabBar
#@onready var top = $UserRetical/Top as Line2D
#@onready var right = $UserRetical/Right as Line2D
#@onready var bottom = $UserRetical/Bottom as Line2D
#@onready var left = $UserRetical/Left as Line2D
@onready var user_retical = $UserRetical
@onready var retical = $UserRetical/retical
@onready var lines_name : String
@onready var lines_index : int

# Called when the node enters the scene tree for the first time
func _ready():
	pass
	
# Called every frame	. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	queue_redraw()


func _draw():
	#Edraw_circle(Vector2 (0,0),DOT_RADIUS,DOT_COLOR) #This basickly means that godot draws a circal at 0,0 and can be controled by DOT_RADIUS and DOT_COLOR
	pass
	
	

func _on_line_length_value_changed(value):
	Retical.top.points[0].y = - value
	Retical.right.points[0].x = value
	Retical.bottom.points[0].y = value
	Retical.left.points[0].x = - value


func _on_line_width_value_changed(value):
	Retical.top.width = value
	Retical.right.width = value
	Retical.bottom.width = value
	Retical.left.width = value


func _on_on_or_off_dot_toggled(toggled_on):
	if toggled_on:
		retical.visible = false
	else:
		retical.visible = true


func _on_on_or_off_line_toggled(toggled_on):
	if toggled_on:
		Retical.top.visible = false
		Retical.right.visible = false
		Retical.bottom.visible = false
		Retical.left.visible = false
	else:
		Retical.top.visible = true
		Retical.right.visible = true
		Retical.bottom.visible = true
		Retical.left.visible = true


func _on_color_picker_button_color_changed(color):
	Retical.top.default_color = color
	Retical.right.default_color = color
	Retical.bottom.default_color = color
	Retical.left.default_color = color
