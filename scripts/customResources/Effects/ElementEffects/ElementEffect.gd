class_name ElementEffect
extends Resource

@export var EffectStrength:float
var EntityHurtbox:HurtboxComponent
var WeaponWithEffect:item

signal callEffect()

var connectOnce = false
func applyEffect(hurtbox:HurtboxComponent, weapon:item) -> void:
	if connectOnce == false:
		callEffect.connect(doEffect.bind(EffectStrength))
		connectOnce = true
	EntityHurtbox = hurtbox
	if weapon:
		WeaponWithEffect = weapon
	callEffect.emit()
	
func doEffect(_Strength:int) -> void:
	assert(false, "This method must be overridden in a subclass")

func createParticles(entity:CharacterBody2D, particlePackedScene:PackedScene) -> CPUParticles2D:
	var Prt = particlePackedScene.instantiate()
	Prt.scale = Vector2(0.5, 0.5)
	Prt.entityAttached = entity
	entity.get_tree().get_root().add_child(Prt)
	return Prt
