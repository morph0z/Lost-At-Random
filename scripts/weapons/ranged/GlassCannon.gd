extends gun

@onready var shatter_points: Node2D = $ShatterPoints
@export var SHATTER_PIECES:PackedScene = preload("res://scenes/objects/inanimte/ammo/GlassShard.tscn")

var funProperties = {
	"statType": "Risky",
	"spaceTimeLocation": "Middle Age"
}

func _ready():
	whenThisItemIsReady()
	weaponShot.connect(_on_weapon_shot)
	#sets ammoAmount to the original ammo amount
	ammoAmount = ammoAmountOriginal
	if shoot_effects:
		for i in shoot_effects:
			i.applyEffect(self)
			


func createGlassShard(shardPosition:Vector2, shardRotation:float):
	var ShatterPieceIns = SHATTER_PIECES.instantiate()
	if ShatterPieceIns is projectile:
		ShatterPieceIns.set_scale(Vector2(0.6, 0.6))
		#sets the damage, position and rotation of the projectile
		if ShatterPieceIns is bullet:
			@warning_ignore("integer_division")
			ShatterPieceIns.bulletDamage = weaponDamage/3
		if ShatterPieceIns is arrow:
			@warning_ignore("integer_division")
			ShatterPieceIns.arrowDamage = weaponDamage/3
		ShatterPieceIns.global_position = shardPosition
		ShatterPieceIns.global_rotation = shardRotation
		ShatterPieceIns.Speed = 500
		ShatterPieceIns.peircingLevel = 0
		if elementEffect:
			ShatterPieceIns.elementEffect = elementEffect
	get_tree().get_root().call_deferred("add_child", ShatterPieceIns)

func _on_weapon_shot():
	var randNum = randi() % 5
	print(randNum)
	if randNum == 3:
		for i:Node2D in shatter_points.get_children():
			createGlassShard(i.global_position, i.global_rotation)
		playerRef.dropItem()
