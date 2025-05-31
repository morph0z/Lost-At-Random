#The Arrow Class
extends projectile
class_name arrow

##this is a class that extends the projectile class and is usally used with bows

##the image of the arrow
@onready var sprite: Sprite2D = $Sprite2D

##this is the value of damage that the arrow does. it usally gets it value from the weapon shooting it.
var arrowDamage:float
##the amount of areas or bodys the arrow goes through.
var goneThrough = 0

##Removes Arrow from world
func DestroyArrow():
	sprite.hide()
	goneThrough = 0
		
func _on_area_entered(area: Area2D) -> void:
	#when the arrow hits a hurtbox (any hurtbox) it will damage it and delete it if it exceds its piercing level
	if area is HurtboxComponent:
		#increases the goneThrough var to remove the arrow if the pircing level have been surpassed
		goneThrough = goneThrough+1
		#checks if the peircinglevel is equal to the gonethrough level to remove the arrow when needed
		if peircingLevel == goneThrough:
			var attack = Attack.new()
			DestroyProjectile(true)
			DestroyArrow()
			attack.attack_damage = arrowDamage
			attack.attack_position = global_position
			area.damage(attack)
			Global.frameFreeze(0.1, 1.5, area.get_parent().get_parent())
		
func _on_body_entered(body: Node2D) -> void:
	#when the arrow colides with any collidable tile it will delete it
	if body.is_in_group("World"):
		DestroyProjectile(true)
		DestroyArrow()
