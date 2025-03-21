extends Node
const MAIN_MENU_UI = preload("res://scenes/ui/mainMenu_ui.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Home"):
		SceneManager.change_scene(MAIN_MENU_UI)
