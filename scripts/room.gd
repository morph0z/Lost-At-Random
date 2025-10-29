extends Node2D
class_name Room
@onready var background: TileMapLayer = $Background
@onready var midground: TileMapLayer = $Midground

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for i in background.get_used_cells(): 
		#if background.get_cell_tile_data(i) == background.get_cell_tile_data(Vector2i(-21,-22)) :
			#print("yo "+str(i)+" is grass")
			#background.get_cell_tile_data(i).set_modulate(Color(0,0,0,0))
			#background.erase_cell(i)
			
func playerInNewRoom(area:Area2D, playerPos: Vector2, Direction:String):
	var FuncDirection
	if area.get_parent() is PlayerClass:
		var playerRef:PlayerClass = area.get_parent()
		var generatedWorldRef:generatingWorld = self.get_parent().get_parent()
		self.get_parent().get_child(0).queue_free()
		generatedWorldRef.clearEnemys()
		generatedWorldRef.clearItems()
		var newRoom = generatedWorldRef.generateRoom()
		generatedWorldRef.spawnEnemys()
		if Direction == "Up":
			FuncDirection = "Area2D"
		elif Direction == "Down":
			FuncDirection = "Area2D2"
		elif Direction == "Left":
			FuncDirection = "Area2D3"
		elif Direction == "Right":
			FuncDirection = "Area2D4"
		playerRef.position = Vector2(newRoom.get_node("Background/"+FuncDirection).position + playerPos)
	if area.get_parent().name == "SeeArea":
		pass
	elif area.get_parent().get_parent() is HurtboxComponent:
		var enemyRef:enemyClass = area.get_parent().get_parent()
		enemyRef.health_component.dead()
#Up area
func _on_area_2d_area_entered(area: Area2D) -> void:
	playerInNewRoom(area, Vector2(0,-40), "Down")

#Down area
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	playerInNewRoom(area, Vector2(0,40), "Up")

#Left area
func _on_area_2d_3_area_entered(area: Area2D) -> void:
	playerInNewRoom(area, Vector2(-40,0), "Right")

#Right area
func _on_area_2d_4_area_entered(area: Area2D) -> void:
	playerInNewRoom(area, Vector2(40,0), "Left")
