extends Area2D

func _process(_delta: float) -> void:
	if visible == true:
		get_child(0).collision_enabled = true
		get_child(0).enabled = true
	else:
		get_child(0).enabled = false
		get_child(0).collision_enabled = false
	
