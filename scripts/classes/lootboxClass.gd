extends Node2D
class_name lootbox

@export var itemLootTable:LoottableComponent 
@export var artifactLootTable:LoottableComponent 

@export var idleParticles:CPUParticles2D
@export var openParticles:CPUParticles2D
@export var sprite:AnimatedSprite2D

const rarityEnum = rarity.new().Rarities

@export var lootboxRarity:rarityEnum = rarityEnum.COMMON

var opened:bool = false

var rarityColor:Color



func _ready() -> void:
	opened = false
	_rarityHandling()

func openLootbox():
	var chosenItem:PackedScene = itemLootTable.pickRandom()
	var chosenArtifact:PackedScene = artifactLootTable.pickRandom()
	
	var chosenItemIns = chosenItem.instantiate()
	var chosenArtifactIns:artifact = chosenArtifact.instantiate()
	
	chosenItemIns.position = self.position
	chosenArtifactIns.position = self.position
	
	sprite.play("Open")
	
	get_tree().get_root().call_deferred("add_child", chosenArtifactIns)
	get_tree().get_root().call_deferred("add_child", chosenItemIns)

	
	openParticles.emitting = true
	idleParticles.emitting = false

func _on_open_area_body_entered(body: Node2D) -> void:
	if body is PlayerClass:
		if opened == false:
			opened = true
			openLootbox()

func _colorHandling():
	if lootboxRarity == rarityEnum.COMMON:
		rarityColor = Color.GRAY
	elif lootboxRarity == rarityEnum.UNCOMMON:
		rarityColor = Color.GREEN
	elif lootboxRarity == rarityEnum.RARE:
		rarityColor = Color.AQUA
	elif lootboxRarity == rarityEnum.GALACTIC:
		rarityColor = Color.WEB_PURPLE
	elif lootboxRarity == rarityEnum.UNIVERSAL:
		rarityColor = Color.ORANGE_RED
	elif lootboxRarity == rarityEnum.RANDOM:
		rarityColor = Color.FUCHSIA
	elif lootboxRarity == rarityEnum.PARADOXICAL:
		rarityColor = Color.BLACK
		
	idleParticles.color = rarityColor
	openParticles.color = rarityColor
	sprite.modulate = rarityColor

func _rarityHandling():
	var raritiyValue:int = 0
	var itemAmount:int = 0
	for i in itemLootTable.LootTable:
		var j = i.instantiate()
		var gotItem:item = j.get_child(0)  
		raritiyValue += gotItem.itemRarity
		itemAmount += 1
		
	@warning_ignore("integer_division")
	var rarityValueAverage:float = raritiyValue/itemAmount
	if (rarityValueAverage >= rarityEnum.COMMON):
		lootboxRarity = rarityEnum.COMMON
	elif (rarityValueAverage <= rarityEnum.COMMON) and (rarityValueAverage >= rarityEnum.UNCOMMON):
		lootboxRarity = rarityEnum.UNCOMMON
	elif (rarityValueAverage <= rarityEnum.UNCOMMON) and (rarityValueAverage >= rarityEnum.RARE):
		lootboxRarity = rarityEnum.RARE
	elif (rarityValueAverage <= rarityEnum.RARE) and (rarityValueAverage >= rarityEnum.GALACTIC):
		lootboxRarity = rarityEnum.GALACTIC
	elif (rarityValueAverage <= rarityEnum.UNIVERSAL) and (rarityValueAverage >= rarityEnum.RANDOM):
		lootboxRarity = rarityEnum.UNIVERSAL
	elif (rarityValueAverage <= rarityEnum.RANDOM) and (rarityValueAverage >= rarityEnum.PARADOXICAL):
		lootboxRarity = rarityEnum.RANDOM
	elif (rarityValueAverage <= rarityEnum.PARADOXICAL):
		lootboxRarity = rarityEnum.PARADOXICAL
	
	_colorHandling()
