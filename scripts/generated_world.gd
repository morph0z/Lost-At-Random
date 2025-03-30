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
		for y in textDungeon().count("#",0,(numOfRooms.y*(3))):
			var room = ROOM_NORMAL_AREA.instantiate()
			var roomDirections = [(room.get_node("enterArea/areaEnterD")),(room.get_node("enterArea/areaEnterU")),(room.get_node("enterArea/areaEnterL")),(room.get_node("enterArea/areaEnterR"))]
			var randomRoomDirections = randi_range(0,4)
			match randomRoomDirections:
				0:
					room.get_node("enterArea/areaEnterD").visible = true
					room.get_node("enterArea/areaEnterU").visible = true
					room.get_node("enterArea/areaEnterL").visible = true
					room.get_node("enterArea/areaEnterR").visible = true
				1:
					var randomDirection1 = roomDirections.pick_random()
					randomDirection1.visible = true
					if randomDirection1.get_child(0).is_colliding() == false:
						randomDirection1.visible = false
				2:
					var randomDirection1 = roomDirections.pick_random()
					var randomDirection2 = roomDirections.pick_random()
					randomDirection1.visible = true
					randomDirection2.visible = true
					if randomDirection1.get_child(0).is_colliding() == false:
						randomDirection1.visible = false
					if randomDirection2.get_child(0).is_colliding() == false:
						randomDirection2.visible = false
				3:
					var randomDirection1 = roomDirections.pick_random()
					var randomDirection2 = roomDirections.pick_random()
					var randomDirection3 = roomDirections.pick_random()
					randomDirection1.visible = true
					randomDirection2.visible = true
					randomDirection3.visible = true
					if randomDirection1.get_child(0).is_colliding() == false:
						randomDirection1.visible = false
					if randomDirection2.get_child(0).is_colliding() == false:
						randomDirection2.visible = false
					if randomDirection3.get_child(0).is_colliding() == false:
						randomDirection3.visible = false
				4:
					var randomDirection1 = roomDirections.pick_random()
					var randomDirection2 = roomDirections.pick_random()
					var randomDirection3 = roomDirections.pick_random()
					var randomDirection4 = roomDirections.pick_random()
					randomDirection1.visible = true
					randomDirection2.visible = true
					randomDirection3.visible = true
					randomDirection4.visible = true
					if randomDirection1.get_child(0).is_colliding() == false:
						randomDirection1.visible = false
					if randomDirection2.get_child(0).is_colliding() == false:
						randomDirection2.visible = false
					if randomDirection3.get_child(0).is_colliding() == false:
						randomDirection3.visible = false
					if randomDirection4.get_child(0).is_colliding() == false:
						randomDirection4.visible = false
					
			rooms.add_child(room)
			room.position = Vector2i((room.position.x+6.5)*(x*100), (room.position.y+6.5)*(y*100))

#CREDIT: Thomas Yanuziello (https://www.youtube.com/watch?v=yl4YrFRXNpk&t=375s)
func textDungeon() -> String:
	var dungeonAsString:String = ""
	for y in range(numOfRooms.y-1,-1,-1):
		for x in numOfRooms.x:
			dungeonAsString += "["+str(roomArray[x][y])+"]" 
		dungeonAsString += "\n"
	return dungeonAsString
