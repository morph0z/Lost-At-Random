extends Node2D
@onready var rooms: Node2D = $Rooms

const HallwayRoom = preload("res://scenes/worlds/Areas/room_hallway_area.tscn")
const LargeRoom = preload("res://scenes/worlds/Areas/room_large_area.tscn")
const LShapeRoom = preload("res://scenes/worlds/Areas/room_L_area.tscn")
const NormalRoom = preload("res://scenes/worlds/Areas/room_normal_area.tscn")
const StartRoom = preload("res://scenes/worlds/Areas/room_start_area.tscn")

const PLAYER = preload("res://scenes/objects/Player.tscn")

var RoomTypes = [HallwayRoom,LargeRoom,LShapeRoom,NormalRoom]
var RoomDirections = ["enterArea/areaEnterU","enterArea/areaEnterL","enterArea/areaEnterR","enterArea/areaEnterD"]
var RoomRotations = [0, 90 , 180, 270]
var randomRoomType
var randomRoomDirectionNum
var randomRoomRotation
var randomDirection
var lastDirection

var directionAmountU:int
var directionAmountD:int
var directionAmountR:int
var directionAmountL:int
#var numberOfRooms = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var StartRoomNew = StartRoom.instantiate()
	var PlayerNew = PLAYER.instantiate()
	rooms.add_child(StartRoomNew)
	add_child(PlayerNew)
	generate_room_structue(10)

func generate_room_structue(numberOfRooms):	
	for i in range(numberOfRooms):
		randomRoomType = randi_range(1,3)
		var RoomNew = RoomTypes[randomRoomType].instantiate()
		rooms.add_child(RoomNew)
		#randomNum = randi_range(0,2)
		randomRoomDirectionNum = randi_range(0,2)
		randomRoomRotation = randi_range(0,3)
		lastDirection = randomDirection
		randomDirection = RoomDirections[randomRoomDirectionNum]
		if lastDirection == randomDirection or lastDirection != randomDirection:
			i = 0
			if randomDirection == "enterArea/areaEnterU":
				i = directionAmountU
				RoomNew.position = RoomNew.position + RoomNew.get_node(randomDirection).position*(randf_range(8,20)*(i+1))
				if lastDirection == "enterArea/areaEnterL" or RoomNew.position.x < 0:
					RoomNew.position.x = RoomNew.position.x - directionAmountR*(180.35)
					#print()
				directionAmountU = directionAmountU+1
				#print(str(directionAmountU)+" ups")
			elif randomDirection == "enterArea/areaEnterD":
				i = directionAmountD
				directionAmountD = directionAmountD+1
				RoomNew.position = RoomNew.position + RoomNew.get_node(randomDirection).position*(randf_range(8,20)*(i+1))
				if lastDirection == "enterArea/areaEnterR" or RoomNew.position.x < 0:
					RoomNew.position.x = RoomNew.position.x + directionAmountR*(180.35)
				#print(str(directionAmountD)+" downs")
			elif randomDirection == "enterArea/areaEnterR":
				i = directionAmountR
				directionAmountR = directionAmountR+1
				RoomNew.position = RoomNew.position + RoomNew.get_node(randomDirection).position*(randf_range(8,20)*(i+1))
				if lastDirection == "enterArea/areaEnterU" or RoomNew.position.y < 0:
					RoomNew.position.y = RoomNew.position.y - directionAmountR*(180.35)
				#print(str(directionAmountR)+" rights")
			elif randomDirection == "enterArea/areaEnterL":
				i = directionAmountL
				directionAmountL = directionAmountL+1
				RoomNew.position = RoomNew.position + RoomNew.get_node(randomDirection).position*(randf_range(8,20)*(i+1))
				if lastDirection == "enterArea/areaEnterD" or RoomNew.position.y < 0:
					RoomNew.position.y = RoomNew.position.y + directionAmountR*(180.35)
				#print(str(directionAmountL)+" lefts")

		print(str(lastDirection)+" is before.   " + str(randomDirection)+" is after.")
		RoomNew.set_rotation(deg_to_rad(RoomRotations[randomRoomRotation]))
		if RoomNew.has_node("enterArea"):
			if RoomNew.has_node("enterArea/areaEnterU"):
				if not RoomNew.get_node("enterArea/areaEnterU").overlaps_area(RoomNew.get_node("enterArea").get_children()[1]):
					RoomNew.set_rotation(deg_to_rad(RoomRotations[randomRoomRotation]))
				else:
					pass
			if RoomNew.has_node("enterArea/areaEnterD"):
				if not RoomNew.get_node("enterArea/areaEnterD").overlaps_area(RoomNew.get_node("enterArea").get_children()[2]):
					RoomNew.set_rotation(deg_to_rad(RoomRotations[randomRoomRotation]))
				else:
					pass
			if RoomNew.has_node("enterArea/areaEnterL"):
				if not RoomNew.get_node("enterArea/areaEnterL").overlaps_area(RoomNew.get_node("enterArea").get_children()[2]):
					RoomNew.set_rotation(deg_to_rad(RoomRotations[randomRoomRotation]))
				else:
					pass
			if RoomNew.has_node("enterArea/areaEnterR"):
				if not RoomNew.get_node("enterArea/areaEnterR").overlaps_area(RoomNew.get_node("enterArea").get_children()[1]):
					RoomNew.set_rotation(deg_to_rad(RoomRotations[randomRoomRotation]))
				else:
					pass
			#if RoomNew.get_node(""):
			#	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_debug_generate_refresh_timeout() -> void:
	generate_room_structue(randi_range(1,10))
