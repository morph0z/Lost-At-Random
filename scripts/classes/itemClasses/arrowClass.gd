extends projectile
class_name arrow
##This is a class that extends the projectile class and is usally used with bows


##This is the value of damage that the arrow does. it usally gets it value from the weapon shooting it.
var arrowDamage:float

##Called when the arrow collides with another area 
func _on_area_entered(area: Area2D) -> void:
	#when the arrow hits a hurtbox (any hurtbox) it will damage it and delete it if it exceds its piercing level
	if area is HurtboxComponent:		
		#damage dealt
		var attack = Attack.new()
		attack.attack_damage = arrowDamage
		attack.attack_position = global_position
		area.damage(attack)
		Global.frameFreeze(0.1, 1.5, area.get_parent().get_parent())
			
##Called when arrow enters another body			
func _on_body_entered(_body: Node2D) -> void:
	pass
