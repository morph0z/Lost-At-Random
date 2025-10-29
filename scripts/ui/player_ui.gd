extends Control
@onready var progress_bar = $ProgressBar
@onready var texture_rect = $TextureRect
@export var player:PlayerClass
@onready var fps_counter: Label = $"Fps Counter"
@onready var stamina_bar: ProgressBar = $StaminaBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
var smoothstepInc:int = 0
func _process(delta):
	smoothstepInc += 1
	fps_counter.set_text("FPS: "+ str(Engine.get_frames_per_second()))
	progress_bar.value = move_toward(progress_bar.value, player.EntityHealth, smoothstepInc*delta)
	if player.EntityHealth == progress_bar.value:
		smoothstepInc = 0
	stamina_bar.value = player.stamina_componet.Stamina
