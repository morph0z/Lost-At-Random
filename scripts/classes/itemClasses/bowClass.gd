#The Bow Class
class_name bow
extends item

##this class extends the item class and is a type of weapon that needs to be charged before a shot is shot.

@onready var attack_cooldown = $AttackCooldown
@onready var bow_shoot_prt = $BowShoot_prt
@onready var shooting_point = $ShootingPoint
@onready var sprite: AnimatedSprite2D = $Sprite

##a signal that gives out the amount of ammo left on the bow
signal ammoChange(ammoAmount)

#instances
##an instance of the arrow type the bow will shoot
const BASIC_Arrow = preload("res://scenes/objects/inanimte/ammo/BasicArrow.tscn")

#attributes
##the cooldown of the weapon?
@export var shootCooldown:float = 1
##the amout multiplyed to the normal cooldown
@export var reloadTimeMultiplyer:float = 3
##the amount of damage that the bow does when the arrow is shot
@export var weaponDamage = 1
@export var ammoAmountOriginal:int
##how fast the bow power level is charged
@export var chargeSpeedMultiplyer:float = 1
##the least charge amount needed for the arrow to shoot
@export var minimumChargeLevel:float = 10
##the max amount of charge so the power does not keep charging
@export var maximumChargeLevel:float = 20

var ammoAmount = ammoAmountOriginal
##the amount of charge the bow has
var chargeLevel = 0



#bools
##the ability of the bow to shoot
var canShoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	whenThisItemIsReady()
	ammoAmount = ammoAmountOriginal

##charges a shot
func chargeShot():
	sprite.play("charge")
	attack_cooldown.start(shootCooldown)
	
##shoots an arrow
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

##shoots a blank
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
