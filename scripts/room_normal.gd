extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().generateRoom()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D2").position + Vector2(0, -40))

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().generateRoom()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D").position + Vector2(0, 40))

func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().generateRoom()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D4").position + Vector2(-40, 0))

func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().generateRoom()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D3").position + Vector2(40, 0))
