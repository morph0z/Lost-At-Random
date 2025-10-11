extends artifact

@export var attackIncrease:float = 1.5

func _ready() -> void:
	artifactEffect.connect(applyArtifactEffect.bind())
	
func applyArtifactEffect(effectStregth:float):
	if playerRef is PlayerClass:
		playerRef.swordStrengthMultiplier = effectStregth*attackIncrease
