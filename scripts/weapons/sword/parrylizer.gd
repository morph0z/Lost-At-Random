extends sword
var shoot = gun.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_sharp_part_area_entered(area: Area2D) -> void:
	if isHeld == true:
		if Swung == true:
			#checks if while the sword is swung if its in an enemy
			if area is bullet:
				area.DestroyBullet()
				shoot.shoot()
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
		
