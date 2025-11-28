extends ElementEffect
class_name BlueLightning

const lightningParticles = preload("res://scenes/particles/lightning_prt.tscn")


func doEffect(Strength:int) -> void:
	var WeaponWithEffectDamage:float
	if WeaponWithEffect:
		WeaponWithEffectDamage = WeaponWithEffect.weaponDamage

	var blueLightningDamage = Attack.new()
	blueLightningDamage.attack_damage = WeaponWithEffectDamage/(10*Strength)

	if EntityHurtbox is HurtboxComponent:
		var particles = createParticles(EntityHurtbox.get_parent().get_parent(), lightningParticles)
		particles.color = Color.ROYAL_BLUE
		for i in range(1, 10*Strength):
			if WeaponWithEffect: WeaponWithEffect.weaponDamage = 0
			await Global.get_tree().create_timer(0.3).timeout
			if EntityHurtbox:
				EntityHurtbox.damage(blueLightningDamage)
				if WeaponWithEffect: WeaponWithEffect.weaponDamage = WeaponWithEffectDamage
		particles.emitting = false
		await particles.finished
		particles.queue_free()
