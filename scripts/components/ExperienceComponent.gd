class_name ExperienceHandler
extends Node

@export var playerRef:PlayerClass
@export var skillPointComponent:SkillpointHandler
@export var debug:bool = false
var xp:float = 0
var level:int = 0
var xpNeededForNextLevel:float = ((level*sqrt(level))/25)*100

var thingHealth:int
var connectOnce = false

signal experienceChanged(newExp:float)
signal levelChanged(newLevel:int)

func start_up() -> void:
	playerRef.itemPicked.connect(_on_item_picked)
	connectOnce = false

func _on_item_picked(itemPicked:item) -> void:
	if connectOnce == false:
		itemPicked.KilledThing.connect(_on_killed_thing)
		connectOnce = true

func increaseLevel(amount:int, override:bool = false):
	if (xp == xpNeededForNextLevel) or (override == true):
		xp = 0
		level += amount
		xpNeededForNextLevel = ((level*sqrt(level))/25)*100
		skillPointComponent.increaseSkillPoints(1)
		levelChanged.emit(level)

func _on_killed_thing(Health:int):
	xp += (Health*2)*playerRef.experienceMultiplier
	xp = clampf(xp, 0, xpNeededForNextLevel)
	experienceChanged.emit(xp)
	if debug:
		print(str(xp) + " xp")
		print(str(level) + " level")
		print(str(xpNeededForNextLevel-xp) + "xp left")
		print('')
		
	increaseLevel(1)
	
