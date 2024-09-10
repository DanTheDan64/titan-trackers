extends Marker3D

var level_selected = 1

#marker rotation.y, cam.position.y, cam.position.z
var level_data = [
	[0, 2, 10],
	[90, 3, 10],
	[45, 6, 10]
]


func _input(event):
	if event is InputEvent:
		var dir = Input.get_axis("left", "right")
		


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
