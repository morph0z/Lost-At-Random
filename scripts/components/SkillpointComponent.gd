extends Node
class_name SkillpointHandler

@export var debug:bool = false
var skillPoints:int = 0

func _ready() -> void:
	if debug:
		skillPoints = 1000

func increaseSkillPoints(amount:int) -> void:
	skillPoints += amount
	skillPoints = clampi(skillPoints, 0, skillPoints)
	
func reduceSkillPoints(amount:int) -> void:
	skillPoints -= amount
	skillPoints = clampi(skillPoints, 0, skillPoints)
	
func getSkillPoints() -> int:
	return skillPoints
