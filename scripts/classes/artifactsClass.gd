class_name artifact extends Node2D
@export var sprite:Sprite2D
@export var pickArea: Area2D
var playerRef:PlayerClass

signal artifactEffect(EffectStrength)

func _on_pick_area_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area.get_parent().get_parent() is PlayerClass:
			var player = area.get_parent().get_parent()
			var j = 0
			for i in player.get_children():
				j += 1
				if i.name == "Artifacts_Buffs":
					call_deferred("reparent", player.get_child(j-1))
					await get_tree().create_timer(Global.globalDelay).timeout
					playerRef = get_parent().get_parent()
					artifactEffect.emit(1)
