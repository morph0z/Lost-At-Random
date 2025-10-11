class_name bow
extends item

##This class extends the item class and is a type of weapon that needs to be charged before a projectile is shot out.

##The cooldown 
@onready var attack_cooldown = $AttackCooldown
##The particles made when a projectie is shot
@onready var bow_shoot_prt = $BowShoot_prt
##The point at where the projectile comes out
@onready var shooting_point = $ShootingPoint
##The sprite for the bow
@onready var sprite: AnimatedSprite2D = $Sprite


##A signal that gives out the amount of ammo left on the bow
signal ammoChange(ammoAmount)

#instances
##An instance of the arrow type the bow will shoot
const BASIC_Arrow = preload("res://scenes/objects/inanimte/ammo/BasicArrow.tscn")

#attributes
##The cooldown of the weapon?
@export var shootCooldown:float = 1
##The amout multiplyed to the normal cooldown
@export var reloadTimeMultiplyer:float = 3
##The amount of damage that the bow does when the arrow is shot
@export var weaponDamage = 1
##The amount of ammo the bow has before any use 
@export var ammoAmountOriginal:int
##How fast the bow power level is charged
@export var chargeSpeedMultiplyer:float = 1
##The least charge amount needed for the arrow to shoot
@export var minimumChargeLevel:float = 10
##The max amount of charge so the power does not keep charging
@export var maximumChargeLevel:float = 20

##The amount of ammo that the bow currently has
var ammoAmount = ammoAmountOriginal
##The amount of charge the bow has
var chargeLevel = 0



#bools
##The ability of the bow to shoot
var canShoot = true

##Called when the node enters the scene tree for the first time.
func _ready():
	#calls when item is ready function
	whenThisItemIsReady()
	#sets ammoAmount to the original ammo amount
	ammoAmount = ammoAmountOriginal

##Charges a shot
func chargeShot():
	#plays charging animation
	sprite.play("charge")
	#starts the attack cooldown timer
	attack_cooldown.start(shootCooldown)
	
##Shoots an arrow
func Shoot():
	#emits the change in ammo for use in the UI
	ammoChange.emit(ammoAmount)
	#reduces ammo amount
	ammoAmount -= 1
	#plays shooting animation
	sprite.play("shoot")
	#creates particles
	bow_shoot_prt.set_emitting(true)
	#creates new arrow
	var ArrowNew = BASIC_Arrow.instantiate()
	#resizes scale (since it is normally to big)
	ArrowNew.set_scale(Vector2(0.3, 0.3))
	#sets the damage the arrow will deal
	if playerRef is PlayerClass:
		var attackMultiplierFromPlayer = playerRef.bowStrengthMultiplier*playerRef.attackStrengthMultiplier
		ArrowNew.arrowDamage = (weaponDamage*(chargeLevel*0.5))*attackMultiplierFromPlayer
	else:
		ArrowNew.arrowDamage = (weaponDamage*(chargeLevel*0.5))
	#DEBUGING PRINT: print(str(ArrowNew.arrowDamage)+" YO")
	
	#sets the rotation and position of the arrow to the shooting point of the bow
	ArrowNew.global_position = shooting_point.global_position
	ArrowNew.global_rotation = shooting_point.global_rotation
	#adds the new arrow to the scene
	get_tree().get_root().add_child(ArrowNew)
	#DEBUGING PRINT: print(ammoAmount)

##Shoots a blank
func emptyShot():
	pass

##Called when an input is entered
func _input(event):
	#checks if the attack button was pressed to call shoot and start a cooldown timer
	if isHeld == true:
		#when the Attack input is held
		if event.is_action_pressed("Attack", true):
			#check if the canShoot var is true or false
			#if true then it begins to charge the shot
			#otherwise it does an empty shot
			if canShoot == true:
				chargeShot()
				#the charge level is directly proportional to itself added to 10% of the chargeSpeedMultiplyer 
				chargeLevel = chargeLevel+(0.1*chargeSpeedMultiplyer)
			if canShoot == false:
				emptyShot()	
		#when the attack input is let go of
		if event.is_action_released("Attack"):
			#check if the canShoot var is true or false
			#if true it checks if the charge level is greater than the minimum charge level
				#if that is true the projectile will be shot and the charge level will be set to zero
				#otherwise the bow shoots an empty shot and sets charge level to zero
			#if false it checks if the charge level is less then the minimum charge level
				#if true it fires an empty shot and sets charge level to zero while playing the shooting animation
			if canShoot == true:
				if chargeLevel >= minimumChargeLevel:
					Shoot()
				if chargeLevel <= minimumChargeLevel:
					emptyShot()
					sprite.play("shoot")
				chargeLevel = 0
			if canShoot == false:
				if chargeLevel <= minimumChargeLevel:
					emptyShot()
					chargeLevel = 0
					sprite.play("shoot")

##Called every frame
func _process(_delta: float) -> void:
	#if the attack input is pressed
	if Input.is_action_pressed("Attack", true):
		#if canShoot is true 
		if canShoot == true:
			#set charge level to itself plus 10% of the charge speed multiplier 
			chargeLevel = chargeLevel+0.1*chargeSpeedMultiplyer
			#sets the charge level to the maximum charge level posible after the charge level has exceded the maximum
			if chargeLevel >= maximumChargeLevel:
				chargeLevel = maximumChargeLevel
		#if ammo amount is less than 0 then
		if ammoAmount <= 0:
			#the bow is out of ammo
			outOfAmmo()
	
	if get_parent().get_parent() is PlayerClass:
		playerRef = get_parent().get_parent()

##Called once the attack cooldown is done
func _on_attack_cooldown_timeout():
	#if the item is currently being held by the player then
	if isHeld == true:
		#if the attack input is held then
		if Input.is_action_pressed("Attack") == true:
			#if the ammo amount is greater then zero
			if ammoAmount > 0:
				#the shot will start charging
				chargeShot()
			#otherwise if the ammo amount is less then zero then
			elif ammoAmount <= 0:
				#the bow is out of ammo
				outOfAmmo()
		#otherwise if the attack input is not pressed then
		else:
			#if the ammo amount is greater than zero then
			if ammoAmount > 0:
				#the ability to shoot is given
				canShoot = true
			#otherwise if the ammo amount is less than zero then
			elif ammoAmount <= 0:
				#the bow is out of ammo
				outOfAmmo()
				
##Called when ammo is less than or equal to zero
func outOfAmmo():
	#ammo is properly set to zero
	ammoAmount = 0
	#ability to shoot is revoked
	canShoot = false
	#timer is made for the relode time
	await get_tree().create_timer(shootCooldown*reloadTimeMultiplyer).timeout
	#sets the ammo amount to the original ammo amount
	ammoAmount = ammoAmountOriginal
	#allows player to shoot
	canShoot = true
	
