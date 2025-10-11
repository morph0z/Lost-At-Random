extends artifact

@export var attackIncrease:float = 1.2

func _ready() -> void:
	artifactEffect.connect(applyArtifactEffect.bind())
	
func applyArtifactEffect(effectStregth:float):
	if playerRef is PlayerClass:
		playerRef.attackStrengthMultiplier = effectStregth*attackIncrease
