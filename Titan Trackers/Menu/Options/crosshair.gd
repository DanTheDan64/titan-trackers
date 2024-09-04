class_name Crosshair
extends TabBar

#@export var DOT_RADIUS :float = 1.0
#@export var DOT_COLOR : Color = Color.WHITE

#@onready var top = $"../../UserRetical/retical/Top" as Line2D
#@onready var right = $"../../UserRetical/retical/Right" as Line2D
#@onready var bottom = $"../../UserRetical/retical/Bottom" as Line2D
#@onready var left = $"../../UserRetical/retical/Left" as Line2D

#@export var top : Color = Color.WHITE



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#queue_redraw()# This code tells to draw any commends that you have put into the script \
	pass


func _draw():
	#Edraw_circle(Vector2 (0,0),DOT_RADIUS,DOT_COLOR) #This basickly means that godot draws a circal at 0,0 and can be controled by DOT_RADIUS and DOT_COLOR
	pass
	
