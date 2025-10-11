extends artifact

@export var attackIncrease:float = 1.8

func _ready() -> void:
	artifactEffect.connect(applyArtifactEffect.bind())
	
func applyArtifactEffect(effectStregth:float):
	if playerRef is PlayerClass:
		playerRef.gunStrengthMultiplier = effectStregth*attackIncrease
