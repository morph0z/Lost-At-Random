extends Node2D
@onready var background: TileMapLayer = $Background
@onready var midground: TileMapLayer = $Midground


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for i in background.get_used_cells(): 
		#if background.get_cell_tile_data(i) == background.get_cell_tile_data(Vector2i(-21,-22)) :
			#print("yo "+str(i)+" is grass")
			#background.get_cell_tile_data(i).set_modulate(Color(0,0,0,0))
			#background.erase_cell(i)
			

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().clearEnemys()
		self.get_parent().get_parent().generateRoom()
		self.get_parent().get_parent().spawnEnemys()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D2").position + Vector2(0, -40))

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().clearEnemys()
		self.get_parent().get_parent().generateRoom()
		self.get_parent().get_parent().spawnEnemys()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D").position + Vector2(0, 40))

func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().clearEnemys()
		self.get_parent().get_parent().generateRoom()
		self.get_parent().get_parent().spawnEnemys()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D4").position + Vector2(-40, 0))

func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		self.get_parent().get_child(0).queue_free()
		self.get_parent().get_parent().clearEnemys()
		self.get_parent().get_parent().generateRoom()
		self.get_parent().get_parent().spawnEnemys()
		area.get_parent().position = Vector2(self.get_node("Background/Area2D3").position + Vector2(40, 0))
