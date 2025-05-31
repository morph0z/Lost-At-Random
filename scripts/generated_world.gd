extends Node2D

@onready var enemys: Node2D = $Enemys
@onready var rooms: Node2D = $Rooms
@export var enemySpawning1: PackedScene = preload("res://scenes/objects/enemy/SimpleEnemy.tscn")
@export var enemySpawning2: PackedScene	= preload("res://scenes/objects/enemy/SimpleEnemy.tscn")
@export var enemySpawning3: PackedScene	= preload("res://scenes/objects/enemy/SimpleEnemy.tscn")
@export var enemySpawning4: PackedScene	= preload("res://scenes/objects/enemy/SimpleEnemy.tscn")
@export var enemySpawning5: PackedScene	= preload("res://scenes/objects/enemy/SimpleEnemy.tscn")
var enemyList = [enemySpawning1.instantiate(),enemySpawning2.instantiate(),enemySpawning3.instantiate(),enemySpawning4.instantiate(),enemySpawning5.instantiate()]
const PLAYERins = preload("res://scenes/objects/Player.tscn")
var player = PLAYERins.instantiate()
var ROOM_NORMAL_AREA = preload("res://scenes/worlds/Areas/room_normal_area.tscn")
var roomPlaceHolderInsance = ROOM_NORMAL_AREA.instantiate()
var enemyPlaceHolders = roomPlaceHolderInsance.get_node("PlaceHolders/Enemys")

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
	var randomEnemy = enemyList.pick_random()
	var currentEnemyPlaceHolder
	for i in enemyPlaceHolders.get_children():
		currentEnemyPlaceHolder = i
		if randomEnemy == null:
			randomEnemy = enemyList.pick_random()
		enemys.add_child(randomEnemy)
		randomEnemy.set_position(currentEnemyPlaceHolder.get_position())
		
func generateRoom():
	var normalRoom = ROOM_NORMAL_AREA.instantiate()
	spawnEnemys()
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
	
	
