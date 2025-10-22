extends CPUParticles2D
class_name attachParticleClass

var entityAttached:CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if entityAttached:
		position = entityAttached.position
