extends sword
const SWORD_BLASTER_BULLET = preload("res://scenes/objects/inanimte/ammo/SwordBlasterBullet.tscn")
@onready var shooting_point: Marker2D = $ShootingPoint
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var charge_prt: CPUParticles2D = $ChargePrt

##How fast the power level is charged
@export var chargeSpeedMultiplyer:float = 1
##The least charge amount needed for the bullet to shoot
@export var minimumChargeLevel:float = 10
##The max amount of charge so the power does not keep charging
@export var maximumChargeLevel:float = 20

var chargeLevel = 0
var funProperties = {
	"statType": "Water",
	"spaceTimeLocation": "Present"
}

func createBullet():
	var BulletIns = SWORD_BLASTER_BULLET.instantiate()
	BulletIns.set_scale(Vector2(0.6, 0.6))
	#sets the damage, position and rotation of the projectile
	BulletIns.bulletDamage = 1*(chargeLevel*0.1)
	BulletIns.global_position = shooting_point.global_position
	BulletIns.global_rotation = shooting_point.global_rotation
	BulletIns.Speed = 500
	BulletIns.peircingLevel = 0
	get_tree().get_root().call_deferred("add_child",BulletIns)

func _input(event):
	#checks if the attack button was pressed to call sword_swing and start a cooldown timer
	if isHeld == true:
		if event.is_action_pressed("Attack"):
			attack_cooldown.start(swingTime)
			sword_swing()
			swingTime= swingTime-originalSwingTime
		if event.is_action_released("Secondary"):
			sprite.play("Shoot")
			charge_prt.emitting = false
			if chargeLevel >= minimumChargeLevel:
				createBullet()
			if chargeLevel <= minimumChargeLevel:
				pass
			chargeLevel = 0
		if event.is_action_pressed("Secondary"):
			sprite.play("Open")
			charge_prt.emitting = true
			
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Secondary", true):
		chargeLevel = chargeLevel+0.1*chargeSpeedMultiplyer
		print(chargeLevel)
		if chargeLevel >= maximumChargeLevel:
			chargeLevel = maximumChargeLevel
			
			
