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

@onready var health_bar = $HealthBar
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var xp_bar: ProgressBar = $XpBar

@onready var pause_menu: Panel = $PauseMenu
@onready var skill_tree: Panel = $PauseMenu/SkillTree
@onready var skill_points: Label = $PauseMenu/SkillTree/SkillPoints

@export_group("Settings")
@export var debug:bool = false

func _ready() -> void:
	xp_bar.value = 0
	
func _process(_delta):
	stamina_bar.value = staminaComp.Stamina
	skill_points.text = "Skill Points: "+str(experienceComp.skillPointComponent.getSkillPoints())
	
	if debug:
		fps_counter.set_text("FPS: "+ str(Engine.get_frames_per_second()))
		fps_counter.visible = debug

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("MenuEscape"):
		if !isPauseMenuOpen():
			openPauseMenu()
		elif isPauseMenuOpen():
			closePauseMenu()

func _on_return_pressed() -> void:
	get_tree().paused = false
	Global.returnToMenu()

func _on_skill_tree_pressed() -> void:
	skill_tree.visible = true

func isPauseMenuOpen() -> bool:
	return pause_menu.visible

func openPauseMenu() -> void:
	pause_menu.visible = true
	get_tree().paused = true
	
func closePauseMenu() -> void:
	pause_menu.visible = false
	skill_tree.visible = false
	get_tree().paused = false


func _on_player_player_health_changed() -> void:
	var healthBarTween:Tween = get_tree().create_tween()
	healthBarTween.tween_property(health_bar, "value", healthComp.HealthPoints, 1)
	healthBarTween.set_ease(Tween.EASE_OUT)
	healthBarTween.set_trans(Tween.TRANS_EXPO)

func _on_player_player_exp_changed() -> void:
	var expBarTween:Tween = get_tree().create_tween()
	expBarTween.tween_property(xp_bar, "value", experienceComp.xp, 1)
	expBarTween.set_ease(Tween.EASE_OUT)
	expBarTween.set_trans(Tween.TRANS_EXPO)

func _on_player_player_level_changed() -> void:
	xp_bar.max_value = player.experience_component.xpNeededForNextLevel
