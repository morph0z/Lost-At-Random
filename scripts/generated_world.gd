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
@export_subgroup("Floor Tiles")
@export var floorTiles:TileSetAtlasSource
@export var floorTilesTexture:Texture2D
@export_subgroup("Wall Tiles")
@export var wallTiles:TileSetAtlasSource
@export var wallTilesTexture:Texture2D
@export_subgroup("Special Tiles")
@export var specialTiles:TileSetAtlasSource
@export var specialTilesTexture:Texture2D

##Array of arrays that are the floor[0] tiles, wall[1] tiles, and object[2] tiles.
@onready var tileSetUsed:Array[TileSetAtlasSource] = [floorTiles, wallTiles, specialTiles]

@export_group("Loot Tables")
@export var itemLootTable:LoottableComponent
@export var artifactLootTable:LoottableComponent

func _ready() -> void:
	add_child(player)
	generateRoom()
	if floorTiles:
		floorTiles.texture = floorTilesTexture
	if wallTiles:
		wallTiles.texture = wallTilesTexture
	if specialTiles:
		specialTiles.texture = specialTilesTexture
	
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
	var randomRoom = roomList.pick_random()
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
		items.add_child(randItem)
		randItem.set_position(currentEnemyPlaceHolder1.get_position()+Vector2(randi_range(0,10),randi_range(0,10)))
	
	if (amountOfRoomsMade%10 == 0) or (amountOfRoomsMade == 5):
		artifacts.add_child(randArtifact)
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
	OpenRoomOpenings.call()
	return randomRoom

#var tileInt
var createTileOnce:bool = false
func replaceRelaceableTiles(tileAtlas:Vector2i, source:TileSetAtlasSource, layer:TileMapLayer):
	
	var newSource  = layer.tile_set.add_source(source)
	if !createTileOnce:
		source.create_tile(tileAtlas, Vector2(2,2))
		createTileOnce = true
	
	print("yo")
	for i in layer.get_used_cells():
		if layer.get_cell_tile_data(i).get_custom_data("replace"):
			layer.set_cell(i, newSource, Vector2.ZERO, 0)
