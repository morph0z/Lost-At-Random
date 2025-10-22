class_name ShootEffect
extends Resource

@export var EffectStrength:float
var WEAPONSHOT:item

signal callEffect()

func applyEffect(weaponShot:item) -> void:
	callEffect.connect(doEffect.bind(EffectStrength))
	WEAPONSHOT = weaponShot
	callEffect.emit()
	
func doEffect(_Strength:int) -> void:
	assert(false, "This method must be overridden in a subclass")
