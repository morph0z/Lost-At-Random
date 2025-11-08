class_name item
extends AnimatableBody2D

var playerRef

#instances
const Player = preload("res://scripts/player/Player.gd") 
var PlayerIn = Player.new()

##The animation player for the item
@onready var animation_player:AnimationPlayer = $AnimationPlayer
##The item hitbox that activates when picking up an item
@onready var item_pick = $ItemPick

##This is only true when the item is held by the player
var isHeld = false

func _process(_delta: float) -> void:
	if get_parent().get_parent() is PlayerClass:
		playerRef = get_parent().get_parent()

##This is called when the item is ready
func whenThisItemIsReady():
	if get_parent().is_in_group("HeldItems") == true:
		animation_player.play("heldF")
		isHeld = true
		item_pick.monitorable = false
		item_pick.monitoring = false
	elif get_parent().is_in_group("HeldItems") == false:
		animation_player.play("onGround")
		isHeld = false
		item_pick.monitoring = true
		item_pick.monitorable = true
	checkIfHeld()

##Function to check if the item is held
func checkIfHeld():
	if get_parent().is_in_group("HeldItems") == true:
		if get_parent().get_child_count(false) == 1:
			animation_player.play("heldF")
		elif get_parent().get_child_count(false) == 2:
			animation_player.play("heldB")
			
		isHeld = true
	elif get_parent().is_in_group("HeldItems") == false:
		animation_player.play("onGround")
		isHeld = false
		
	if isHeld == true:
		item_pick.call_deferred("set_monitorable", false)
		item_pick.call_deferred("set_monitoring", false)
	elif isHeld == false:
		item_pick.call_deferred("set_monitorable", true)
		item_pick.call_deferred("set_monitoring", true)
