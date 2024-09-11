extends CenterContainer

@export var DOT_RADIUS:float = 1.0
@export var DOT_COLOR: Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()# This code tells to draw any commends that you have put into the script 

func _draw():
	draw_circle(Vector2 (0,0),DOT_RADIUS,DOT_COLOR) #This basickly means that godot draws a circal at 0,0 and can be controled by DOT_RADIUS and DOT_COLOR
