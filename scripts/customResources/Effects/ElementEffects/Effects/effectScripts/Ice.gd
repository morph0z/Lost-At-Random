extends ElementEffect

func doEffect(Strength:int) -> void:
	if WeaponWithEffect.get_parent().get_parent() is PlayerClass:
		var playerRef:PlayerClass = WeaponWithEffect.get_parent().get_parent()
		playerRef.isOnIce = true
