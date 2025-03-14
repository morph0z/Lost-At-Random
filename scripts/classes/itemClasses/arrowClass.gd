extends projectile
class_name arrow

@onready var sprite: Sprite2D = $Sprite2D

var arrowDamage:float
var goneThrough = 0

func DestroyArrow():
	sprite.hide()
	goneThrough = 0
	
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		goneThrough = goneThrough+1
		if peircingLevel == goneThrough:
			var attack = Attack.new()
			DestroyProjectile(true)
			DestroyArrow()
			attack.attack_damage = arrowDamage
			attack.attack_position = global_position
			area.damage(attack)
			PlayerIn.frameFreeze(0.005, 3.346, area.get_parent().get_parent())
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("World"):
		DestroyProjectile(true)
		DestroyArrow()
