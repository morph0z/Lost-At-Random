extends CPUParticles2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	await finished
	if get_parent() == get_tree().get_root():
		queue_free()
