extends sword
@onready var marker_2d: Marker2D = $ShootingPoint
const PARRYLIZER_BULLET = preload("res://scenes/objects/inanimte/ammo/ParrylizerBullet.tscn")

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
	get_tree().get_root().call_deferred("add_child",ParryBulletIns)
	get_tree().get_root().print_tree_pretty()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_sharp_part_area_entered(area: Area2D) -> void:
	if isHeld == true:
		if Swung == true:
			#checks if while the sword is swung if its in an enemy
			if area is bullet:
				area.DestroyProjectile(true, area.visual)
				createParryBullet()
			if area is HurtboxComponent:
				var attack = Attack.new()
				attack.attack_damage = weaponDamage
				attack.knockback_force = weaponKnockback
				attack.hit_cooldown = originalSwingTime
				attack.attack_position = global_position
				
				var camera = get_parent().get_parent().get_node("Camera")
				area.damage(attack)
				sword_hit_prt.set_emitting(true)
				camera.randomStrength = 2
				camera.apply_shake()
				Global.frameFreeze(0.1, 1, area.get_parent().get_parent())
