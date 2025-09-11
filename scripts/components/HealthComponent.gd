extends Node
class_name HealthComponent

const MAIN_MENU_UI = preload("res://scenes/ui/mainMenu_ui.tscn")
@onready var damaged_timer: Timer = $damagedTimer

@export var HealthPoints: int
var isDead = false

#signal hitting

func damage(attack: Attack):
	HealthPoints -= attack.attack_damage
	if HealthPoints <= 0:
		HealthPoints = 0
		dead()


func dead():
	HealthPoints = 0
	if get_parent().get_parent() is PlayerClass:
		var player = $"../.."
		if isDead == false:
			player.player_death_prt.set_emitting(true)
			if player.isHolding == 2:
				player.holding_two.hide()
			elif player.isHolding <= 1:
				player.holding_one.hide()
			await get_tree().create_timer(1).timeout
			SceneManager.change_scene(MAIN_MENU_UI.instantiate())
			isDead = true
	elif get_parent().get_parent().name != "Player":
		get_parent().get_parent().animation_player.play("Death")
