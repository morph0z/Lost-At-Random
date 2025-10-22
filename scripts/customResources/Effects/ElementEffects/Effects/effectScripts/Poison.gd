extends ElementEffect
class_name Poison

const poisonParticles = preload("res://scenes/particles/poison_prt.tscn")

func doEffect(Strength:int) -> void:
	#for i in range(1,Strength*5):
	var poisonDamage = Attack.new()
	poisonDamage.attack_damage = Strength
	if EntityHurtbox is HurtboxComponent:
		var particles = createParticles(EntityHurtbox.get_parent().get_parent(), poisonParticles)
		for i in range(1, 25):
			await Global.get_tree().create_timer(1).timeout
			if EntityHurtbox:
				EntityHurtbox.damage(poisonDamage)
		particles.emitting = false
		await particles.finished
		particles.queue_free()
