extends Node2D
class_name generatingWorld

@onready var enemys: Node2D = $Enemys
@onready var rooms: Node2D = $Rooms
@onready var items: Node2D = $Items
@onready var artifacts: Node2D = $Artifacts
const PLAYERins = preload("res://scenes/objects/Player.tscn")
var player = PLAYERins.instantiate()
var ROOM_NORMAL_AREA = preload("res://scenes/worlds/Areas/baseAreas/room_normal_area.tscn")
var roomPlaceHolderInsance = ROOM_NORMAL_AREA.instantiate()
var ROOM_L_AREA = preload("res://scenes/worlds/Areas/baseAreas/room_L_area.tscn")
var enemyPlaceHolders = roomPlaceHolderInsance.get_node("PlaceHolders/Enemys")
var enemylist:Array = []

var randomAmountRoomOpenings:int
var randomRoomOpening
var amountOfRoomsMade:int = 0

##Sets the number of rooms in the total of the dungeon before boss room.
#NOTE make the difficulty of the mode change the range of the amount of rooms
@export var numOfRooms:int = randi_range(10,20)
#NOTE make player go to next area once numOfRooms is finished.
@export var nextArea:PackedScene
@export_group("Tile Set")
@export var tileSetTexture:Texture2D
@export_subgroup("Floor Tiles")
@export var floorTiles:TileSetAtlasSource
@export var floorTilesTexturePosition:Vector2
@export_subgroup("Wall Tiles")
@export var wallTiles:TileSetAtlasSource
@export var wallTilesTexturePosition:Vector2
@export_subgroup("Special Tiles")
@export var specialTiles:TileSetAtlasSource
@export var specialTilesTexturePosition:Vector2

##Array of arrays that are the floor[0] tiles, wall[1] tiles, and object[2] tiles.
@onready var tileSetUsed:Array[TileSetAtlasSource] = [floorTiles, wallTiles, specialTiles]

@export_group("Loot Tables")
@export var itemLootTable:LoottableComponent
@export var artifactLootTable:LoottableComponent

func _ready() -> void:
	add_child(player)
	if floorTiles:
		floorTiles.texture = tileSetTexture
		floorTiles.texture_region_size = Vector2(16,16)*2
		floorTiles.create_tile(floorTilesTexturePosition)
	if wallTiles:
		wallTiles.texture = tileSetTexture
		wallTiles.texture_region_size = Vector2(16,16)*2
		wallTiles.create_tile(wallTilesTexturePosition)
	if specialTiles:
		specialTiles.texture = tileSetTexture
		specialTiles.create_tile(wallTilesTexturePosition)
	generateRoom()
	
	
func spawnEnemys():
	var BasicEnemy: PackedScene = preload("res://scenes/objects/enemy/SimpleEnemy.tscn")
	#NOTE replace the 5 with the increasing amount of enemys due to higher levels
	var randomEnemyAmount = randi_range(0, 5)
	for i in range(randomEnemyAmount):
		var basicEnemyInstance = BasicEnemy.instantiate()
		var currentEnemyPlaceHolder = enemyPlaceHolders.get_child(randi_range(0,3))
		enemys.call_deferred("add_child", basicEnemyInstance)
		basicEnemyInstance.set_position(currentEnemyPlaceHolder.get_position()+Vector2(randi_range(0,15),randi_range(0,15)))
		enemylist.append(basicEnemyInstance)
		
func clearItems():
	for i in items.get_children():
		i.queue_free()

func clearEnemys():
	var listInc:int = 0
	for i in enemylist:
		listInc += 1
		if (i in enemys.get_children()) == false:
			enemylist.remove_at(listInc-1)
		else:
			i.queue_free()
		enemylist.remove_at(listInc-1)

func generateRoom():
	
#region RoomInstances
	var normalRoom = ROOM_NORMAL_AREA.instantiate()
	var lShapedRoom = ROOM_L_AREA.instantiate()
	var roomList = [normalRoom, lShapedRoom]
	var randomRoom:Room = roomList.pick_random()
#endregion
	
#region LootTables
	var randItem = itemLootTable.pickRandom().instantiate()
	var randArtifact = artifactLootTable.pickRandom().instantiate()
#endregion
	
	var currentEnemyPlaceHolder1 = enemyPlaceHolders.get_child(randi_range(0,3))
	var _currentEnemyPlaceHolder2 = enemyPlaceHolders.get_child(randi_range(0,3))
	
	amountOfRoomsMade += 1
#region Item/Artifact Drops
	if (amountOfRoomsMade%5 == 0) or (amountOfRoomsMade == 1):
		items.call_deferred("add_child", randItem)
		randItem.set_position(currentEnemyPlaceHolder1.get_position()+Vector2(randi_range(0,10),randi_range(0,10)))
	
	if (amountOfRoomsMade%10 == 0) or (amountOfRoomsMade == 5):
		artifacts.call_deferred("add_child", randArtifact)
		randArtifact.set_position(currentEnemyPlaceHolder1.get_position()+Vector2(randi_range(0,10),randi_range(0,10)))
#endregion
		
#region RandomRoomOpenings
	var roomOpenings = ["enterArea/areaEnterU","enterArea/areaEnterD","enterArea/areaEnterL","enterArea/areaEnterR"]
	var OpenRoomOpenings = func():
		randomAmountRoomOpenings = randi_range(1,4)
		for i in range(randomAmountRoomOpenings):
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			randomRoom.get_node(randomRoomOpening).visible = false
#endregion
			
	rooms.call_deferred("add_child", randomRoom)
	replaceRelaceableTiles(floorTilesTexturePosition, floorTiles, randomRoom.background)
	replaceRelaceableTiles(wallTilesTexturePosition, wallTiles, randomRoom.midground)
	#for i in randomRoom.entrances:
	#	replaceRelaceableTiles(wallTilesTexturePosition, wallTiles, i)
	OpenRoomOpenings.call()
	return randomRoom

func replaceRelaceableTiles(tileAtlasPos:Vector2 ,source:TileSetAtlasSource, layer:TileMapLayer):
	var addOnePhysicsLayer:bool = false
	if layer:
		var newSource = layer.tile_set.add_source(source)
		layer.tile_set.add_physics_layer()
		for i in layer.get_used_cells():
			var tile_data = layer.get_cell_tile_data(i)
			var Collideable = tile_data.get_custom_data("collide")
			var Uncollideable = !tile_data.get_custom_data("collide")
			#print(str(Collideable) + " " +str(i)+" "+str(layer))
			if Collideable:
				print("C"+" "+str(layer))
				layer.set_cell(i, newSource, tileAtlasPos, 0)
				if !addOnePhysicsLayer:
					tile_data.add_collision_polygon(layer.tile_set.get_physics_layers_count()-1)
					@warning_ignore("integer_division")
					var tile_extents := Vector2(layer.tile_set.tile_size.x, layer.tile_set.tile_size.y)
					tile_data.set_collision_polygon_points(
						layer.tile_set.get_physics_layers_count()-1, 0, 
						PackedVector2Array(
							[
								Vector2(-tile_extents.x, -tile_extents.y), 
								Vector2(-tile_extents.x, tile_extents.y), 
								Vector2(tile_extents.x, tile_extents.y),  
								Vector2(tile_extents.x, -tile_extents.y)
							]
						)
					)
					addOnePhysicsLayer = true
			if Uncollideable:
				print("Uc"+" "+str(layer))
				layer.set_cell(i, newSource, tileAtlasPos, 0)
