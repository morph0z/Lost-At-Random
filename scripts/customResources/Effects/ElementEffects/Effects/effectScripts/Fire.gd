extends ElementEffect
class_name Fire

const fireParticles = preload("res://scenes/particles/fire_prt.tscn")

func doEffect(Strength:int) -> void:
	#for i in range(1,Strength*5):
	var fireDamage = Attack.new()
	fireDamage.attack_damage = Strength
	if EntityHurtbox is HurtboxComponent:
		var particles = createParticles(EntityHurtbox.get_parent().get_parent(), fireParticles)
		for i in range(1, 10):
			await Global.get_tree().create_timer(1).timeout
			if EntityHurtbox:
				EntityHurtbox.damage(fireDamage)
				EntityHurtbox.isOnFire = true
		particles.emitting = false
		await particles.finished
		particles.queue_free()
		if EntityHurtbox:
			EntityHurtbox.isOnFire = false
