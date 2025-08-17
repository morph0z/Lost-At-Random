extends Polygon2D

var shootoutthing = preload("res://scenes/objects/inanimte/ammo/BasicBullet.tscn")
#var shootoutthing = preload("res://scenes/objects/inanimte/ammo/ParrylizerBullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body

func _input(event: InputEvent) -> void:
	if event.is_action("Attack"):
		var shootoutthingIns = shootoutthing.instantiate()
		shootoutthingIns.set_scale(Vector2(0.5, 0.5))
		#sets the damage, position and rotation of the projectile
		shootoutthingIns.bulletDamage = 1
		shootoutthingIns.global_position = position
		shootoutthingIns.global_rotation = rotation
		
		shootoutthingIns.Speed = 60
		await get_tree().create_timer(1).timeout
		get_tree().get_root().add_child(shootoutthingIns)
