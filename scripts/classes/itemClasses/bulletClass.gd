extends projectile
class_name bullet
##This class is extends the projectile class and is relatively the same to the arrow class

##The ammount of damage done by the bullet (usally set by the weapon shooting it)
var bulletDamage:float
	
##Called when bullet enters an area	
func _on_area_entered(area: Area2D) -> void:
	#checks if the area entered is a hurtbox
	if area is HurtboxComponent:
		#it deals damage
		var attack = Attack.new()
		#destroys the bullet
		DestroyProjectile(true, visual)
		attack.attack_damage = bulletDamage
		attack.attack_position = global_position
		area.damage(attack)
		#adds framestop
		Global.frameFreeze(0.1, 1.5, area.get_parent().get_parent())

##Called when bullet hits another area
func _on_body_entered(_body: Node2D) -> void:
	pass
