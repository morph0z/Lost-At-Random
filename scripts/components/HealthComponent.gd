extends Node
class_name HealthComponent


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
	if get_parent().get_parent().name == "Player":
		var player = $"../.."
		if isDead == false:
			player.player_death_prt.set_emitting(true)
			if player.isHolding == 2:
				player.holding_two.hide()
			elif player.isHolding <= 1:
				player.holding_one.hide()
			await get_tree().create_timer(1).timeout
			player.queue_free()
			isDead = true
	elif get_parent().get_parent().name != "Player":
		get_parent().get_parent().animation_player.play("Death")
