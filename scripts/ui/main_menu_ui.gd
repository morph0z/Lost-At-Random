extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var PlayButton: Button = $Play
const GENERATED_WORLD = preload("res://scenes/worlds/generated_world.tscn")
const TEST_WORLD = preload("res://scenes/worlds/test_world.tscn")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var maxMusicVolume:int = 1
@export var minMusicVolume:int = 0

func _ready() -> void:
	animation_player.play("GameStart")
	await animation_player.animation_finished
	animation_player.play("TitleIdle")

func _process(delta: float) -> void:
	easeMusicIn(delta, 1, maxMusicVolume, minMusicVolume)

var i = 0
func easeMusicIn(_delta:float, speed:float, maxVolume:int = 10, minVolume:int = 0):
	i += (speed/1000)*(maxMusicVolume)
	audio_stream_player.volume_linear = clampf(lerp(minVolume, maxVolume, i), 0, maxVolume)

func _on_play_pressed() -> void:
	SceneManager.change_scene(GENERATED_WORLD)

func _on_play_test_pressed() -> void:
	SceneManager.change_scene(TEST_WORLD)
