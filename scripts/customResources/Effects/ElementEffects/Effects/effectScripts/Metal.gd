extends ElementEffect
class_name Metal

const metalParticles = preload("res://scenes/particles/metal_prt.tscn")

var doEffectLimit:bool = false
var reduceAttackSpeedOnce:bool = false
var effectDamageInc:int = 0
func doEffect(Strength:int) -> void:
	if EntityHurtbox is HurtboxComponent:
		if !reduceAttackSpeedOnce:
			reduceAttackSpeedOnce = true
			if (WeaponWithEffect is gun) or (WeaponWithEffect is bow):
				WeaponWithEffect.shootCooldown += Strength
			if (WeaponWithEffect is sword) or (WeaponWithEffect is scythe):
				WeaponWithEffect.originalSwingTime += Strength
		if !doEffectLimit:
			effectDamageInc += 5*Strength
			WeaponWithEffect.weaponDamage += effectDamageInc
			if effectDamageInc > 10*Strength:
				doEffectLimit = true
		var particles = createParticles(EntityHurtbox.get_parent().get_parent(), metalParticles)
		particles.emitting = true
		await particles.finished
		particles.queue_free()
