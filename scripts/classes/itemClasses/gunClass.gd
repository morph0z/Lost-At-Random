class_name gun
extends item

@onready var attack_cooldown = $AttackCooldown
@onready var gun_shoot_prt = $GunShoot_prt
@onready var shooting_point = $ShootingPoint

signal ammoChange(ammoAmount)

const BASIC_BULLET = preload("res://scenes/objects/inanimte/ammo/BasicBullet.tscn")

#attributes
@export var shootCooldown:float = 1
@export var reloadTimeMultiplyer:float = 3
@export var weaponDamage = 1
@export var ammoAmountOriginal:int

var ammoAmount = ammoAmountOriginal

#bools
var canShoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	whenThisItemIsReady()
	ammoAmount = ammoAmountOriginal

func shoot():
	ammoChange.emit(ammoAmount)
	gun_shoot_prt.set_emitting(true)
	var BulletNew = BASIC_BULLET.instantiate()
	BulletNew.set_scale(Vector2(0.1, 0.1))
	BulletNew.bulletDamage = weaponDamage
	BulletNew.global_position = shooting_point.global_position
	BulletNew.global_rotation = shooting_point.global_rotation
	get_tree().get_root().add_child(BulletNew)
	attack_cooldown.start(shootCooldown)
	ammoAmount = ammoAmount-1

func emptyShot():
	pass

func _input(event):
	#checks if the attack button was pressed to call sword_swing and start a cooldown timer
	if isHeld == true:
		if event.is_action_pressed("Attack"):
			if canShoot == true:
				shoot()
				canShoot = false
			if canShoot == false:
				emptyShot()

func _on_attack_cooldown_timeout():
	if isHeld == true:
		if Input.is_action_pressed("Attack") == true:
			if ammoAmount > 0:
				shoot()
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
				
func _on_ammo_change():
	print("yea")
