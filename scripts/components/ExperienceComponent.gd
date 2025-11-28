class_name ExperienceHandler
extends Node

@export var playerRef:PlayerClass
var xp:float
var level:int

var thingHealth:int

func _ready() -> void:
	if playerRef.items:
		playerRef.itemPicked.connect(_on_item_picked.bind(playerRef.items.get_children()))
	
func _on_item_picked(itemPicked:Array[item]) -> void:
	for i in itemPicked:
		i.KilledThing.connect(_on_killed_thing.bind(thingHealth))
		
func _on_killed_thing(Health:int):
	print(Health)
