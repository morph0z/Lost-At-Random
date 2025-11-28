extends sword
@onready var marker_2d: Marker2D = $ShootingPoint
const PARRYLIZER_BULLET = preload("res://scenes/objects/inanimte/ammo/ParrylizerBullet.tscn")
@onready var sprite: AnimatedSprite2D = $Sprite

var funProperties = {
	"statType": "Electric",
	"spaceTimeLocation": "Futuristic"
}

func createParryBullet():
	var ParryBulletIns = PARRYLIZER_BULLET.instantiate()
	ParryBulletIns.set_scale(Vector2(0.6, 0.6))
	#sets the damage, position and rotation of the projectile
	ParryBulletIns.bulletDamage = 1
	ParryBulletIns.global_position = marker_2d.global_position
	ParryBulletIns.global_rotation = marker_2d.global_rotation
	ParryBulletIns.Speed = 500
	ParryBulletIns.peircingLevel = 0
	if elementEffect:
		ParryBulletIns.elementEffect = elementEffect
	get_tree().get_root().call_deferred("add_child",ParryBulletIns)
	sprite.play("Swing")

#Overwrites the _on_sharp_part_area_entered from the sword class
func _on_sharp_part_area_entered(area: Area2D) -> void:
	if isHeld == true:
		if Swung == true:
			#checks if while the sword is swung if its in an enemy
			if area is bullet:
				area.DestroyProjectile()
				Global.frameFreeze(0.1, 1.5, area.get_parent().get_parent())
				createParryBullet()
				
			if area is HurtboxComponent:
				area.damage(dealDamage(area))
				juiceEffects(area)
				
				if area.health_component.isDead:
					KilledThing.emit(area.health_component.MaxHealthPoints)
