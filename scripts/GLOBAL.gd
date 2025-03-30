extends Node
const MAIN_MENU_UI = preload("res://scenes/ui/mainMenu_ui.tscn")

func _input(_event):
	#Exit to main menu
	if SceneManager._current_scene.name != MAIN_MENU_UI.instantiate().name:
		if Input.is_action_pressed("Home"):
			SceneManager.change_scene(MAIN_MENU_UI)
	
