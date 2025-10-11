class_name StaminaComponent extends Node

@onready var stamina_regen_cooldown: Timer = $StaminaRegenCooldown
@export var RegenCooldown:float = 10
@export var StaminaRegenInc:int = 1
@export var OriginalStamina = 50
var Stamina = OriginalStamina
var canUseStamina = true

func _ready() -> void:
	stamina_regen_cooldown.wait_time = RegenCooldown

func _process(_delta: float) -> void:
	if Stamina >= OriginalStamina:
		canUseStamina = true

func _on_stamina_regen_cooldown_timeout() -> void:
	canUseStamina = false
	while Stamina <= OriginalStamina:
		Stamina = Stamina+StaminaRegenInc
		await get_tree().create_timer(0.05).timeout

var drainingStamina = false
func startStaminaDrain(amount: int, speed: float):
	if canUseStamina:
		drainingStamina = true
		while drainingStamina:
			Stamina -= amount
			await get_tree().create_timer(speed).timeout

func stopStaminaDrain():
	drainingStamina = false
	
func useStamina(amount):
	if canUseStamina and (Stamina != 0) and (Stamina > OriginalStamina%(amount)):
		Stamina -= amount
