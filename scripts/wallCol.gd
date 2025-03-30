extends TileMapLayer
#@onready var ray_ca_u: RayCast2D = $".././RayCaU"

func _process(_delta: float) -> void:
	if visible == true:
		collision_enabled = true
		get_child(0).enabled = true
	else:
		get_child(0).enabled = false
		collision_enabled = false
	
