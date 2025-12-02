extends Control
class_name PlayerGui

@export_group("Refrences")
@export var player:PlayerClass
@export var healthComp:HealthComponent
@export var staminaComp:StaminaComponent
@export var experienceComp:ExperienceHandler
@export var skillpointComp:SkillpointHandler

@onready var texture_rect = $TextureRect

@onready var fps_counter: Label = $"Fps Counter"

@onready var progress_bar = $HealthBar
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var xp_bar: ProgressBar = $XpBar

@onready var pause_menu: Panel = $PauseMenu

@export_group("Settings")
@export var debug:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
var smoothstepIncHealth:int = 0
var smoothstepIncXp:int = 0
func _process(delta):
	fps_counter.set_text("FPS: "+ str(Engine.get_frames_per_second()))
	
	smoothstepIncHealth += 1
	progress_bar.value = move_toward(progress_bar.value, healthComp.HealthPoints, smoothstepIncHealth*delta)
	if healthComp.HealthPoints == progress_bar.value:
		smoothstepIncHealth = 0

	smoothstepIncXp += 1
	xp_bar.value = move_toward(xp_bar.value,  experienceComp.xp, smoothstepIncXp*delta) 
	if experienceComp.xp == progress_bar.value:
		smoothstepIncXp = 0

	stamina_bar.value = staminaComp.Stamina

	#xp_bar.max_value = player.experience_component.xpNeededForNextLevel
	if debug:
		fps_counter.visible = debug

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("MenuEscape"):
		if !isPauseMenuOpen():
			openPauseMenu()
		elif isPauseMenuOpen():
			closePauseMenu()

func _on_return_pressed() -> void:
	get_tree().paused = false
	Global.returnToMenu()

func _on_skill_tree_pressed() -> void:
	pass # Replace with function body.

func isPauseMenuOpen() -> bool:
	return pause_menu.visible

func openPauseMenu() -> void:
	pause_menu.visible = true
	get_tree().paused = true
	
func closePauseMenu() -> void:
	pause_menu.visible = false
	get_tree().paused = false
