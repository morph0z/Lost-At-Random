extends Node2D

@onready var enemys: Node2D = $Enemys
@onready var rooms: Node2D = $Rooms
@onready var items: Node2D = $Items
@onready var artifacts: Node2D = $Artifacts
const PLAYERins = preload("res://scenes/objects/Player.tscn")
var player = PLAYERins.instantiate()
var ROOM_NORMAL_AREA = preload("res://scenes/worlds/Areas/room_normal_area.tscn")
var roomPlaceHolderInsance = ROOM_NORMAL_AREA.instantiate()
var ROOM_L_AREA = preload("res://scenes/worlds/Areas/room_L_area.tscn")
var enemyPlaceHolders = roomPlaceHolderInsance.get_node("PlaceHolders/Enemys")
var enemylist:Array = []

var randomAmountRoomOpenings:int
var randomRoomOpening
var amountOfRoomsMade:int = 0

##Sets the number of rooms in the total of the dungeon before boss room.
#NOTE make the difficulty of the mode change the range of the amount of rooms
@export var numOfRooms:int = randi_range(10,20)
@export var itemLootTable:PackedScene
@export var artifactLootTable:PackedScene
@onready var InsItemLootTable = itemLootTable.instantiate()
@onready var InsArtifactLootTable = artifactLootTable.instantiate()

func _ready() -> void:
	add_child(player)
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
	var normalRoom = ROOM_NORMAL_AREA.instantiate()
	var lShapedRoom = ROOM_L_AREA.instantiate()
	var roomList = [normalRoom, lShapedRoom]
	var randomRoom = roomList.pick_random()
	
	var ItemLootTableDuplicate = InsItemLootTable.duplicate(8)
	var ArtifactLootTableDuplicate = InsArtifactLootTable.duplicate(8)
	
	var randomItem:Node2D = ItemLootTableDuplicate.get_children().pick_random()
	var randomArtifact:artifact = ArtifactLootTableDuplicate.get_children().pick_random()
	
	var currentEnemyPlaceHolder1 = enemyPlaceHolders.get_child(randi_range(0,3))
	var currentEnemyPlaceHolder2 = enemyPlaceHolders.get_child(randi_range(0,3))
	
	amountOfRoomsMade += 1
	if (amountOfRoomsMade%5 == 0) or (amountOfRoomsMade == 1):
		randomItem.call_deferred("reparent", items)
		randomItem.set_position(currentEnemyPlaceHolder1.get_position()+Vector2(randi_range(0,10),randi_range(0,10)))
	
	if (amountOfRoomsMade%10 == 0) or (amountOfRoomsMade == 5):
		randomArtifact.call_deferred("reparent", artifacts)
		randomArtifact.set_position(currentEnemyPlaceHolder2.get_position()+Vector2(randi_range(0,10),randi_range(0,10)))
		
	var roomOpenings = ["enterArea/areaEnterU","enterArea/areaEnterD","enterArea/areaEnterL","enterArea/areaEnterR"]
	var OpenRoomOpenings = func():
		randomAmountRoomOpenings = randi_range(1,4)
		for i in range(randomAmountRoomOpenings):
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			randomRoom.get_node(randomRoomOpening).visible = false
			
	rooms.call_deferred("add_child", randomRoom)
	OpenRoomOpenings.call()
	return randomRoom
