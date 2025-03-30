extends Node2D

@onready var rooms: Node2D = $Rooms
const PLAYERins = preload("res://scenes/objects/Player.tscn")
var player = PLAYERins.instantiate()
const ROOM_NORMAL_AREA = preload("res://scenes/worlds/Areas/room_normal_area.tscn")

##Sets the number of rooms in X dimention and the Y dimention.
@export var numOfRooms:Vector2i = Vector2i(10,5)

var roomArray:Array
	
func _ready() -> void:
	for x in numOfRooms.x:
		roomArray.append([])
		for y in numOfRooms.y:
			roomArray[x].append("#")
			
	add_child(player)
	print(textDungeon())
	generateGameDungeon()
	
	
func generateGameDungeon() -> void:
	for x in textDungeon().count("#",0,(numOfRooms.x*(3))) :
		var roomX = ROOM_NORMAL_AREA.instantiate()
		rooms.add_child(roomX)
		roomX.position = Vector2i((roomX.position.x+6.5)*(x*100), (roomX.position.y))
		for y in textDungeon().count("#",0,(numOfRooms.y*(3))):
			var roomY = ROOM_NORMAL_AREA.instantiate()
			rooms.add_child(roomY)
			roomY.position = Vector2i((roomY.position.x+6.5)*(x*100), (roomY.position.y+6.5)*(y*100))

#CREDIT: Thomas Yanuziello (https://www.youtube.com/watch?v=yl4YrFRXNpk&t=375s)
func textDungeon() -> String:
	var dungeonAsString:String = ""
	for y in range(numOfRooms.y-1,-1,-1):
		for x in numOfRooms.x:
			dungeonAsString += "["+str(roomArray[x][y])+"]" 
		dungeonAsString += "\n"
	return dungeonAsString
