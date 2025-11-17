class_name ShootEffect
extends Resource

@export var EffectStrength:float
var WEAPONSHOT:item

signal callEffect()

var connectOnce:bool = false
func applyEffect(weaponShot:item) -> void:
	if !connectOnce:
		callEffect.connect(doEffect.bind(EffectStrength))
		connectOnce = true
	WEAPONSHOT = weaponShot
	callEffect.emit()
	
func doEffect(_Strength:int) -> void:
	assert(false, "This method must be overridden in a subclass")
