extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$"../../player".kills_needed += 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func hit():
	$CPUParticles3D.set_emitting(false)
	$MeshInstance3D.hide()
	$CollisionShape3D.disabled = true
	await get_tree().create_timer( \
	$CPUParticles3D.lifetime * 2).timeout
	queue_free()
