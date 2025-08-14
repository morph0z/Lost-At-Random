class_name gun
extends item

##The cooldown 
@onready var attack_cooldown = $AttackCooldown
##The particles made when a projectie is shot
@onready var gun_shoot_prt = $GunShoot_prt
##The point at where the projectile comes out
@onready var shooting_point = $ShootingPoint

##A signal that gives out the amount of ammo left on the gun
signal ammoChange(ammoAmount)

#instances
##An instance of the bullet type the gun will shoot
@export var BULLET:PackedScene

#attributes
##The cooldown on each shot
@export var shootCooldown:float = 1
##The multiplyer that determines how long the reload takes
@export var reloadTimeMultiplyer:float = 3
##The damage that the projectile will deal once shot
@export var weaponDamage = 1
##The amount of ammo that the weapon holds
@export var ammoAmountOriginal:int

##The amount of ammo that the bow currently has
var ammoAmount = ammoAmountOriginal

#bools
##If the gun is able to shot a projectile or not
var canShoot = true

##Called when the node enters the scene tree for the first time.
func _ready():
	whenThisItemIsReady()
	#sets ammoAmount to the original ammo amount
	ammoAmount = ammoAmountOriginal

##The function that shoots a projectile out the gun
func shoot():
	#emits the change in ammo for use in the UI
	ammoChange.emit(ammoAmount)
	#creates particles for the shooting of the projectile
	gun_shoot_prt.set_emitting(true)
	#creates a new bullet instance
	var BulletNew = BULLET.instantiate()
	#rescales the projectile thats shot
	BulletNew.set_scale(Vector2(0.5, 0.5))
	#sets the damage, position and rotation of the projectile
	BulletNew.bulletDamage = weaponDamage
	BulletNew.global_position = shooting_point.global_position
	BulletNew.global_rotation = shooting_point.global_rotation
	#adds the projectile to the scene
	get_tree().get_root().add_child(BulletNew)
	#starts the cooldown after the shot
	attack_cooldown.start(shootCooldown)
	#reduces the ammo amount
	ammoAmount = ammoAmount-1

##This function does absolutly nothing
func emptyShot():
	pass

##This function is called when an input is press
func _input(event):
	#checks if the item is held
	if isHeld == true:
		#if the input pressed is the attack input
		if event.is_action_pressed("Attack"):
			#if the gun can shoot then
			if canShoot == true:
				#it shoots and sets the ability to shoot false
				shoot()
				canShoot = false
			#otherwise it does nothing
			if canShoot == false:
				emptyShot()

##Called when the cooldown of the gun is done
func _on_attack_cooldown_timeout():
	#checks if the item is held
	if isHeld == true:
		#if the input is the attack input then
		if Input.is_action_pressed("Attack") == true:
			#if the ammo amount is greater than zero
			if ammoAmount > 0:
				#the projectile is shot
				shoot()
			#if the ammo amount is less then zero
			elif ammoAmount <= 0:
				#the ammo is set to be exactly zero
				ammoAmount = 0
				#the ability to shoot is revoked
				canShoot = false
				#a timer is set with the shoot cooldown multiplied by the reload multiplyer
				await get_tree().create_timer(shootCooldown*reloadTimeMultiplyer).timeout
				#once the timer is done the ammo is reloaded and the gun can shoot again
				ammoAmount = ammoAmountOriginal
				canShoot = true
		#if the input is not the attack input then		
		else:
			#if the ammo amount is greater than zero then
			if ammoAmount > 0:
				#the gun can shoot
				canShoot = true
			#if the ammo amount is less then or equal to zero then
			elif ammoAmount <= 0:
				#the ammo amount is set exactly to zero
				ammoAmount = 0
				#removes the ability to shoot
				canShoot = false
				#a timer is set with the shoot cooldown multiplied by the reload multiplyer
				await get_tree().create_timer(shootCooldown*reloadTimeMultiplyer).timeout
				#reloads the ammo
				ammoAmount = ammoAmountOriginal
				#sets the ability to shoot back to true
				canShoot = true
				
##Called when the ammo changes
func _on_ammo_change():
	pass
