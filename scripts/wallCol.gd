extends TileMapLayer

func _process(_delta: float) -> void:
	if visible == true:
		collision_enabled = true
	else:
		collision_enabled = false
