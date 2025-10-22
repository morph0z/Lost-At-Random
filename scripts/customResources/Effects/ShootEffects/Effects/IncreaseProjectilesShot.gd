extends ShootEffect 
class_name IncreaseProjectilesShot

#override
func doEffect(Strength:int) -> void:
	if WEAPONSHOT is gun:
		WEAPONSHOT.bulletsBeingShot += Strength
	if WEAPONSHOT is bow:
		WEAPONSHOT.bulletsBeingShot += Strength
