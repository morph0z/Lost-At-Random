extends item
class_name scythe



@onready var attack_cooldown = $AttackCooldown
@onready var scythe_slash = $ScytheSlash
@onready var scythe_hit_prt = $ScytheHit_prt

@export var weaponDamage:int
@export var originalSwingTime:float
@export var weaponKnockback:float = 0

var swingTime = originalSwingTime
var changeSwingTime = originalSwingTime

var Swung = false

# Called when the node enters the scene tree for the first time.
func _ready():
	whenThisItemIsReady()
	
#swing function made to start particles and set swung to true
func scythe_swing():
	if isHeld == true:
		if swingTime == originalSwingTime or swingTime == 0:
			scythe_slash.set_emitting(true)
			Swung = true
			
func _input(event):
	#checks if the attack button was pressed to call sword_swing and start a cooldown timer
	if isHeld == true:
		if event.is_action_pressed("Attack"):
			attack_cooldown.start(swingTime)
			scythe_swing()
			swingTime= swingTime-originalSwingTime
			
func _on_attack_cooldown_timeout():
	if isHeld == true:
		attack_cooldown.stop()
		Swung = false
		scythe_slash.set_emitting(false)
		#when the timer goes out it stops particles and sets swung to false	
		if swingTime <= originalSwingTime*-1:
			swingTime =	swingTime*-1
			if swingTime == originalSwingTime:
				swingTime = originalSwingTime
				
func _on_sharp_part_area_entered(area: Area2D) -> void:
	if isHeld == true:
		if Swung == true:
			#checks if while the sword is swung if its in an enemy
			if area is HurtboxComponent:
				var attack = Attack.new()
				attack.attack_damage = weaponDamage
				attack.knockback_force = weaponKnockback
				attack.hit_cooldown = originalSwingTime
				attack.attack_position = global_position
				
				var camera = get_parent().get_parent().get_node("Camera")
				area.damage(attack)
				scythe_hit_prt.set_emitting(true)
				camera.randomStrength = weaponDamage
				camera.apply_shake()
				Global.frameFreeze(0.1, 1, area.get_parent().get_parent())
