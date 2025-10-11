class_name HealthComponent extends Node 

const MAIN_MENU_UI = preload("res://scenes/ui/mainMenu_ui.tscn")
@onready var damaged_timer: Timer = $damagedTimer

@export var HealthPoints: int
@export var StateMachine: LimboHSM
@export var Entity: CharacterBody2D
var isDead = false

#signal hitting

func damage(attack: Attack):
	HealthPoints -= attack.attack_damage
	if HealthPoints <= 0:
		HealthPoints = 0
		dead()


func dead():
	HealthPoints = 0
	if Entity is PlayerClass:
		if isDead == false:
			Entity.player_death_prt.set_emitting(true)
			Entity.sprite.hide()
			Entity.state_machine.change_active_state(Entity.dead_state)
			isDead = true
			await get_tree().create_timer(3).timeout
			SceneManager.change_scene(MAIN_MENU_UI.instantiate())
			
	elif Entity is not PlayerClass:
		get_parent().get_parent().animation_player.play("Death")
