extends ElementEffect
class_name Ice

const iceParticles = preload("res://scenes/particles/ice_prt.tscn")

func doEffect(Strength:int) -> void:
	if WeaponWithEffect.get_parent().get_parent() is PlayerClass:
		var playerRef:PlayerClass = WeaponWithEffect.get_parent().get_parent()
		var particles = createParticles(playerRef, iceParticles)
		playerRef.isOnIce = true
		await playerRef.get_tree().create_timer(Strength).timeout
		playerRef.isOnIce = false
		particles.emitting = false
		await particles.finished
		particles.queue_free()
