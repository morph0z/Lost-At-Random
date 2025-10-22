extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var PlayButton: Button = $Play
const GENERATED_WORLD = preload("res://scenes/worlds/generated_world.tscn")
const TEST_WORLD = preload("res://scenes/worlds/test_world.tscn")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	animation_player.play("GameStart")
	await animation_player.animation_finished
	animation_player.play("TitleIdle")

func _on_play_pressed() -> void:
	SceneManager.change_scene(GENERATED_WORLD)

func _on_play_test_pressed() -> void:
	SceneManager.change_scene(TEST_WORLD)
