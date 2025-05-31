extends Control
@onready var progress_bar = $ProgressBar
@onready var texture_rect = $TextureRect
@export var player:PlayerClass
@onready var fps_counter: Label = $"Fps Counter"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fps_counter.set_text("FPS: "+ str(Engine.get_frames_per_second()))
	progress_bar.value = player.EntityHealth
