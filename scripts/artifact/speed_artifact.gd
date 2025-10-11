extends artifact

@export var speedIncrease:float = 50

func _ready() -> void:
	artifactEffect.connect(applyArtifactEffect.bind())
	
func applyArtifactEffect(effectStregth:float):
	if playerRef is PlayerClass:
		playerRef.walkSpeed += speedIncrease*effectStregth
		playerRef.sprintSpeed += speedIncrease*effectStregth
		playerRef.SPEED = playerRef.walkSpeed
