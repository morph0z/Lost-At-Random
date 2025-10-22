extends artifact

@export var staminaIncrease:int = 100

func _ready() -> void:
	artifactEffect.connect(applyArtifactEffect.bind())
	

func applyArtifactEffect(effectStregth:float):
	if playerRef is PlayerClass:
		var StamIncEffctStr:int = staminaIncrease*int(effectStregth)
		playerRef.player_ui.stamina_bar.max_value += StamIncEffctStr
		@warning_ignore("integer_division")
		playerRef.stamina_componet.RegenCooldown = int(StamIncEffctStr/100)
		playerRef.stamina_componet.OriginalStamina += StamIncEffctStr
		@warning_ignore("integer_division")
		playerRef.stamina_componet.StaminaRegenInc = int(staminaIncrease/10)
		playerRef.stamina_componet.Stamina = playerRef.stamina_componet.OriginalStamina
