extends Node
class_name LoottableComponent

@export var LootTable:Array[PackedScene]

func pickRandom() -> PackedScene:
	return LootTable.pick_random()
