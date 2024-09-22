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
#@onready var lines_name : String
#@onready var lines_index : int

# Called when the node enters the scene tree for the first time
func _ready():
	pass
	
# Called every frame	. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	queue_redraw()
	user_retical.get_tree().get_first_node_in_group("retical")


func _draw():
	#Edraw_circle(Vector2 (0,0),DOT_RADIUS,DOT_COLOR) #This basickly means that godot draws a circal at 0,0 and can be controled by DOT_RADIUS and DOT_COLOR
	pass
	
	

func _on_line_length_value_changed(value):
	if is_node_ready():
		user_retical.get_tree().get_first_node_in_group("retical").top.points[0].y = - value
		user_retical.get_tree().get_first_node_in_group("retical").right.points[0].x = value
		user_retical.get_tree().get_first_node_in_group("retical").bottom.points[0].y = value
		user_retical.get_tree().get_first_node_in_group("retical").left.points[0].x = - value


func _on_line_width_value_changed(value):
	user_retical.get_tree().get_first_node_in_group("retical").top.width = value
	user_retical.get_tree().get_first_node_in_group("retical").right.width = value
	user_retical.get_tree().get_first_node_in_group("retical").bottom.width = value
	user_retical.get_tree().get_first_node_in_group("retical").left.width = value


func _on_on_or_off_dot_toggled(toggled_on):
	if toggled_on:
		retical.visible = false
	else:
		retical.visible = true


func _on_on_or_off_line_toggled(toggled_on):
	if toggled_on:
		user_retical.get_tree().get_first_node_in_group("retical").top.visible = false
		user_retical.get_tree().get_first_node_in_group("retical").right.visible = false
		user_retical.get_tree().get_first_node_in_group("retical").bottom.visible = false
		user_retical.get_tree().get_first_node_in_group("retical").left.visible = false
	else:
		user_retical.get_tree().get_first_node_in_group("retical").top.visible = true
		user_retical.get_tree().get_first_node_in_group("retical").right.visible = true
		user_retical.get_tree().get_first_node_in_group("retical").bottom.visible = true
		user_retical.get_tree().get_first_node_in_group("retical").left.visible = true


func _on_color_picker_button_color_changed(color):
	user_retical.get_tree().get_first_node_in_group("retical").top.default_color = color
	user_retical.get_tree().get_first_node_in_group("retical").right.default_color = color
	user_retical.get_tree().get_first_node_in_group("retical").bottom.default_color = color
	user_retical.get_tree().get_first_node_in_group("retical").left.default_color = color


func _on_dot_size_value_changed(value):
	user_retical.get_tree().get_first_node_in_group("retical").DOT_RADIUS = value
