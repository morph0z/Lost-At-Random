class_name bow
extends item

@onready var attack_cooldown = $AttackCooldown
@onready var bow_shoot_prt = $BowShoot_prt
@onready var shooting_point = $ShootingPoint
@onready var sprite: AnimatedSprite2D = $Sprite

signal ammoChange(ammoAmount)

#instances
const Player = preload("res://scripts/Player.gd") 
var PlayerIn = Player.new()

const BASIC_Arrow = preload("res://scenes/objects/inanimte/ammo/BasicArrow.tscn")

#attributes
@export var shootCooldown:float = 1
@export var reloadTimeMultiplyer:float = 3
@export var weaponDamage = 1
@export var ammoAmountOriginal:int
@export var chargeSpeedMultiplyer:float = 1
@export var minimumChargeLevel:float = 10
@export var maximumChargeLevel:float = 20

var ammoAmount = ammoAmountOriginal
var chargeLevel = 0



#bools
var canShoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	whenThisItemIsReady()
	ammoAmount = ammoAmountOriginal

func chargeShot():
	sprite.play("charge")
	attack_cooldown.start(shootCooldown)
	
func Shoot():
	ammoChange.emit(ammoAmount)
	ammoAmount = ammoAmount-1
	sprite.play("shoot")
	bow_shoot_prt.set_emitting(true)
	var ArrowNew = BASIC_Arrow.instantiate()
	ArrowNew.set_scale(Vector2(0.3, 0.3))
	ArrowNew.arrowDamage = weaponDamage*(chargeLevel*0.5)
	print(str(ArrowNew.arrowDamage)+" YO")
	ArrowNew.global_position = shooting_point.global_position
	ArrowNew.global_rotation = shooting_point.global_rotation
	get_tree().get_root().add_child(ArrowNew)
	print(ammoAmount)

func emptyShot():
	pass

func _input(event):
	#checks if the attack button was pressed to call sword_swing and start a cooldown timer
	if isHeld == true:
		if event.is_action_pressed("Attack", true):
			if canShoot == true:
				chargeShot()
				chargeLevel = chargeLevel+0.1*chargeSpeedMultiplyer
			if canShoot == false:
				emptyShot()
		if event.is_action_released("Attack"):
			if canShoot == true:
				if chargeLevel >= minimumChargeLevel:
					Shoot()
					chargeLevel = 0
				if chargeLevel <= minimumChargeLevel:
					emptyShot()
					chargeLevel = 0
					sprite.play("shoot")
			if canShoot == false:
				if chargeLevel <= minimumChargeLevel:
					emptyShot()
					chargeLevel = 0
					sprite.play("shoot")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Attack", true):
		if canShoot == true:
			chargeLevel = chargeLevel+0.1*chargeSpeedMultiplyer
			if chargeLevel >= maximumChargeLevel:
				chargeLevel = maximumChargeLevel
		if ammoAmount <= 0:
			ammoAmount = 0
			canShoot = false
			await get_tree().create_timer(shootCooldown*reloadTimeMultiplyer).timeout
			ammoAmount = ammoAmountOriginal
			canShoot = true

func _on_attack_cooldown_timeout():
	if isHeld == true:
		if Input.is_action_pressed("Attack") == true:
			if ammoAmount > 0:
				chargeShot()
			elif ammoAmount <= 0:
				ammoAmount = 0
				canShoot = false
				await get_tree().create_timer(shootCooldown*reloadTimeMultiplyer).timeout
				ammoAmount = ammoAmountOriginal
				canShoot = true
		else:
			if ammoAmount > 0:
				canShoot = true
			elif ammoAmount <= 0:
				ammoAmount = 0
				canShoot = false
				await get_tree().create_timer(shootCooldown*reloadTimeMultiplyer).timeout
				ammoAmount = ammoAmountOriginal
				canShoot = true
