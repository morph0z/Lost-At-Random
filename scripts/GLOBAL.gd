extends Node
const MAIN_MENU_UI = preload("res://scenes/ui/mainMenu_ui.tscn")

var globalDelay:float = 0.5

func _input(_event):
	#Exit to main menu
	if SceneManager._current_scene.name != MAIN_MENU_UI.instantiate().name:
		if Input.is_action_pressed("Home"):
			SceneManager.change_scene(MAIN_MENU_UI)
	
#NOTE fix the damage flash effect
func frameFreeze(timeScale, duration, flash):
	Engine.time_scale = timeScale*0.5
	#joyStickSense = timeScale*duration*0.08
	#flash.
	await get_tree().create_timer(duration*0.02).timeout
	#flash.set_modulate(Color(1,1,1,1))
	Engine.time_scale = 1.0
	#joyStickSense = 0.5
	
