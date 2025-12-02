extends Node
class_name SkillpointHandler

var skillPoints:int = 0

func increaseSkillPoints(amount:int) -> void:
	skillPoints += amount
	
func reduceSkillPoints(amount:int) -> void:
	skillPoints -= amount
	
func getSkillPoints() -> int:
	return skillPoints
