extends Node2D

#CREDIT TO Thomas Yanuziello https://www.youtube.com/watch?v=yl4YrFRXNpk
class_name dungeonGen

@onready var rooms: Node2D = $Rooms
@export var _dimensions:Vector2i
@export var _start:Vector2i
@export var _critical_path_length:int
@export var _branches:int
@export var _branches_lenght:Vector2i = Vector2i(1,4)
var dungeon:Array
var _branch_candidates:Array[Vector2i]

const HallwayRoom = preload("res://scenes/worlds/Areas/room_hallway_area.tscn")
const LargeRoom = preload("res://scenes/worlds/Areas/room_large_area.tscn")
const LShapeRoom = preload("res://scenes/worlds/Areas/room_L_area.tscn")
const NormalRoom = preload("res://scenes/worlds/Areas/room_normal_area.tscn")
const StartRoom = preload("res://scenes/worlds/Areas/room_start_area.tscn")
const PLAYER = preload("res://scenes/objects/Player.tscn")

var RoomTypes = [HallwayRoom,LargeRoom,LShapeRoom,NormalRoom]
var randomRoomType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initilize_dungeon()
	_place_entrance()
	_generate_critical_path(_start, _critical_path_length,"C")
	_generate_branches()
	_print_dungeon()
	
func _print_dungeon() -> void:
	var dungeon_as_string:String = ""
	for y in range(_dimensions.y-1,-1,-1):
		for x in _dimensions.x:
			if dungeon[x][y]:
				dungeon_as_string += "["+str(dungeon[x][y])+"]"
			else:
				dungeon_as_string += "   "
		dungeon_as_string += '\n'
	print(dungeon_as_string)
	
func _initilize_dungeon() -> void:
	for x in _dimensions.x:
		dungeon.append([])
		for y in _dimensions.y:
			dungeon[x].append(0)
			
func _place_entrance() -> void:
	if _start.x < 0 or _start.x >= _dimensions.x:
		_start.x = randi_range(0,_dimensions.x-1)
	if _start.y < 0 or _start.y >= _dimensions.y:
		_start.y = randi_range(0,_dimensions.y-1)
	dungeon[_start.x][_start.y] = "S"
	
func _generate_critical_path(from:Vector2i, length:int, marker:String) -> bool:
	if length == 0:
		return true
	var current: Vector2i = from
	var direction: Vector2i
	match randi_range(0,3):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.RIGHT
		2:
			direction = Vector2i.DOWN
		3:
			direction = Vector2i.LEFT
	for i in 4:
		if (current.x + direction.x >= 0 and current.x + direction.x < _dimensions.x and
			current.y + direction.y >= 0 and current.y + direction.y < _dimensions.y and
			not dungeon[current.x + direction.x][current.y + direction.y]):
				current += direction
				dungeon[current.x][current.y] = length
				if length > 1:
					_branch_candidates.append(current)
				if _generate_critical_path(current, length-1, marker):
					return true
				else:
					_branch_candidates.erase(current)
					dungeon[current.x][current.y] = 0
					current -= direction
		direction = Vector2(direction.y, -direction.x)
	return false
	
func _generate_branches() -> void:
	var branches_created:int = 0
	var candidate:Vector2i
	while branches_created < _branches:
		candidate = _branch_candidates[randi_range(0, _branch_candidates.size()-1)]
		if _generate_critical_path(candidate,randi_range(_branches_lenght.x,_branches_lenght.y),str(branches_created+1)):
			branches_created += 1
		else:
			_branch_candidates.erase(candidate)
	
# THIS IS ALL ME THO			
func _visualize_generation():
	pass
