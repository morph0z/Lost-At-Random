extends Node
class_name SkillpointHandler

@export var debug:bool = false
var skillPoints:int = 0

signal skillPointChanged(newSkillPoints:int)

func _ready() -> void:
	if debug:
		skillPoints = 1000

func increaseSkillPoints(amount:int) -> void:
	skillPoints += amount
	skillPoints = clampi(skillPoints, 0, skillPoints)
	skillPointChanged.emit(skillPoints)
	
func reduceSkillPoints(amount:int) -> void:
	skillPoints -= amount
	skillPoints = clampi(skillPoints, 0, skillPoints)
	skillPointChanged.emit(skillPoints)
	
func getSkillPoints() -> int:
	return skillPoints
