extends LimboState

@export var animation_player:AnimationPlayer
@export var animation:StringName

func _process(delta: float) -> void:
	if self.is_active():
		animation_player.play(animation)
