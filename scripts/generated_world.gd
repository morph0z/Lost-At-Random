extends Node2D

@onready var enemys: Node2D = $Enemys
@onready var rooms: Node2D = $Rooms
const PLAYERins = preload("res://scenes/objects/Player.tscn")
var player = PLAYERins.instantiate()
var ROOM_NORMAL_AREA = preload("res://scenes/worlds/Areas/room_normal_area.tscn")
var roomPlaceHolderInsance = ROOM_NORMAL_AREA.instantiate()
var enemyPlaceHolders = roomPlaceHolderInsance.get_node("PlaceHolders/Enemys")
var enemylist:Array = []

var randomAmountRoomOpenings:int
var randomRoomOpening
##Sets the number of rooms in the total of the dungeon before boss room.
#NOTE make the difficulty of the mode change the range of the amount of rooms
@export var numOfRooms:int = randi_range(10,20)

func _ready() -> void:
	randomAmountRoomOpenings = randi_range(1,4)
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
		basicEnemyInstance.set_position(currentEnemyPlaceHolder.get_position()+Vector2(randi_range(0,10),randi_range(0,10)))
		enemylist.append(basicEnemyInstance)

func clearEnemys():
	var listInc:int = 0
	for i in enemylist:
		listInc += 1
		i.queue_free()
		enemylist.remove_at(listInc-1)

func generateRoom():
	var normalRoom = ROOM_NORMAL_AREA.instantiate()
	var roomOpenings = ["enterArea/areaEnterU","enterArea/areaEnterD","enterArea/areaEnterL","enterArea/areaEnterR"]
	rooms.call_deferred("add_child", normalRoom)
	match randomAmountRoomOpenings:
		1:
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
		2:
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
		3:
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
		4:
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
			randomRoomOpening = roomOpenings[randi_range(0,3)]
			normalRoom.get_node(randomRoomOpening).visible = false
	return normalRoom
	
	
