extends projectile
class_name bullet

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var shape:Node2D

var bulletDamage:float
var goneThrough = 0

func DestroyBullet():
	#shape.hide()
	goneThrough = 0
	
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		goneThrough = goneThrough+1
		if peircingLevel == goneThrough:
			var attack = Attack.new()
			DestroyProjectile(true)
			DestroyBullet()
			attack.attack_damage = bulletDamage
			attack.attack_position = global_position
			area.damage(attack)
			PlayerIn.frameFreeze(0.005, 3.346, area.get_parent().get_parent())
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("World"):
		shape.queue_free()
		DestroyProjectile(true)
		DestroyBullet()
