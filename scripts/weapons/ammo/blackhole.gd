extends bullet
@onready var pull_area: Area2D = $pullArea
var entity:CharacterBody2D

func _on_pull_area_body_entered(body: Node2D) -> void:
	if (body is enemyClass):
		entity = body
		
@onready var modLerpInc:float = 0
var modRed:float
var modGreen:float
var modBlue:float
func _process(_delta: float) -> void:
	for i in pull_area.get_overlapping_bodies():
		if i == entity:
			if entity is enemyClass:
				modLerpInc += 0.1
				entity.Target = self
				modRed = move_toward(0, 255, modLerpInc)
				entity.modulate = Color(modRed, 0, 0)
				entity.gettingPulled()
