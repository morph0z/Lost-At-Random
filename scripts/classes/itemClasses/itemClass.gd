class_name item
extends AnimatableBody2D

#
@onready var animation_player = $AnimationPlayer
@onready var item_pick = $ItemPick

#bool
var isHeld = false

# Called when the node enters the scene tree for the first time.
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

	#function to check if the item is held
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

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
