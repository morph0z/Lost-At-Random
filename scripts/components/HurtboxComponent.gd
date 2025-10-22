class_name HurtboxComponent extends Area2D


@export var health_component: HealthComponent
var isOnFire:bool = false
var fireIns = Fire.new()


func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)

var setFireOnce = false
func _process(_delta: float) -> void:
	if isOnFire:
		for i in get_overlapping_areas():
			if i is HurtboxComponent:
				if !setFireOnce:
					fireIns.applyEffect(i, null)
					setFireOnce = true
	if !isOnFire:
		setFireOnce = false
