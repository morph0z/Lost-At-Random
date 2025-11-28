extends Node
class_name LoottableComponent

@export var LootTable:Array[PackedScene]

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

func pickRandom() -> PackedScene:
	return LootTable.pick_random()
