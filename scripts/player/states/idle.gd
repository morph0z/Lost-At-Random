extends LimboState

@export var animation_player:AnimationPlayer
@export var animation:StringName

func _update(_delta: float) -> void:
		animation_player.play(animation)
		
func _enter() -> void:
	pass
