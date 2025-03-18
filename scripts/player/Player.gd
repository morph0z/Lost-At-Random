extends CharacterBody2D
class_name PlayerClass
@onready var sprint_dust = $Particles/SprintDust
@onready var player_got_hit_prt = $Particles/PlayerGotHitPrt
@onready var player_death_prt: CPUParticles2D = $Particles/PlayerDeathPrt
@onready var animation_player = $AnimationPlayer
@onready var items = $Items
@onready var camera = $Camera
@onready var holding_one = $Polygons/HoldingOne
@onready var holding_two = $Polygons/HoldingTwo
@onready var shadow_h_2 = $Shadows/ShadowH2
@onready var shadow_h_1 = $Shadows/ShadowH1

#State Machine
@export var state_machine : LimboHSM

#States
@onready var idle_state = $LimboHSM/Idle
@onready var walking_state = $LimboHSM/Walking

#--------------------------------------------------------------------------------

signal itemPicked 

#componets
@onready var health_component = $Componets/HealthComponent

#-------------------------------------------------------------------------------

#settings
var joyStickSense = 0.5

#-------------------------------------------------------------------------------

#atrributes
var SPEED = 100.0
#var EnemyStrenghtMultiplyer = 1
var Health

#-------------------------------------------------------------------------------

#bools
var slowmotimer = null	
var isHolding = 0

#-------------------------------------------------------------------------------

func _ready():
	_initialize_state_machine()
	animation_player.play("RESET")
	health_component.HealthPoints = 100

func _initialize_state_machine():
	state_machine.initial_state = idle_state
	state_machine.initialize(self)
	state_machine.set_active(true)

#-------------------------------------------------------------------------------

func _input(event):
	#checks if player is dead duh
	if health_component.isDead == false:
		#turns player when right joystick is moved		
		var aim_dir = Vector2(Input.get_axis("TurnLeft", "TurnRight"), Input.get_axis("TurnUp", "TurnDown")) 
		if aim_dir != Vector2.ZERO:
			rotation = lerp_angle(rotation, aim_dir.angle(), joyStickSense)
			
		#checks if slow motion is not happening so it will stop any rotations when it happends
		if slowmotimer == null:
			#turns player by facing player towards mouse cursor
			if event is InputEventMouseMotion:
				look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("SprintShift"):
			SPEED = 200
			sprint_dust.get_child(0).set_emitting(true)
			animation_player.speed_scale = 2
	elif Input.is_action_just_released("SprintShift"):
			SPEED = 100
			sprint_dust.get_child(0).set_emitting(false)
			animation_player.speed_scale = 1
	
	
	#ITEM DROPPING SYSTEM
	if Input.is_action_pressed("Drop"):
		#checks if the player has one item or not
		if items.get_child(0) != null:
			items.get_child(0).animation_player.play("Drop")
			if items.get_child(1) != null:
				items.get_child(1).animation_player.play("heldF")
			elif items.get_child(1) == null:
				pass
			await get_tree().create_timer(items.get_child(0).animation_player.current_animation_length).timeout
			if items.get_child(0) != null:
				items.get_child(0).queue_free()
			isHolding = isHolding-1
			holding_one.show()
			holding_two.hide()
		elif items.get_child(0) == null:
			pass

#-------------------------------------------------------------------------------

func _physics_process(_delta):
	#this is for movement 
	#var directionY = Input.get_axis("UpW", "DownS")
	#var directionX = Input.get_axis("LeftA", "RightD")
	#if directionX:
		#velocity.x = directionX * SPEED
		#state_machine.change_active_state(walking_state)
	#elif directionY:
		#velocity.y = directionY * SPEED
		#state_machine.change_active_state(walking_state)
	#if not directionY:
		#state_machine.change_active_state(idle_state)
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	#if not directionX:
		#state_machine.change_active_state(idle_state)
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction = Input.get_vector("LeftA","RightD","UpW","DownS")
	if direction != Vector2.ZERO:
		velocity = direction*SPEED
	elif direction ==Vector2.ZERO:
		velocity = Vector2.ZERO

	move_and_slide()	

#-------------------------------------------------------------------------------

func frameFreeze(timeScale, duration, flash):
	Engine.time_scale = timeScale*0.1
	joyStickSense = timeScale*duration*0.08
	flash.set_modulate(Color(10000, 10000, 10000, 1))
	await flash.get_tree().create_timer(timeScale * duration).timeout
	flash.set_modulate(Color(1,1,1,1))
	Engine.time_scale = 1.0
	joyStickSense = 0.5
	
#-------------------------------------------------------------------------------	

#for checking if an area2d node enetered the pickupzone
func _on_pick_up_zone_area_entered(area):
	#checks if it has the name of item pick
	if area.get_name() == "ItemPick":
		#checks if player is holding 2 items already
		if isHolding < 2:
			#checks if it is acctually a pickable item
			if area.get_parent().is_in_group("PickableItem"):
				#procceds to reparent the item and sets the item to being held
				var Pickitem = area.get_parent()
				itemPicked.emit(Pickitem)
				Pickitem.isHeld = true
				Pickitem.checkIfHeld()
				Pickitem.call_deferred("reparent", items, false)
				#Pickitem.reparent(items, false)
				#adds 0.5 beacause it adds 2 when touched once
				isHolding = isHolding+0.5
				print(isHolding)
				if isHolding == 2:
					holding_one.hide()
					holding_two.show()
					shadow_h_1.hide()
					shadow_h_2.show()
			
func _process(_delta):
	#checks if player has 1 or less items to change the item holding polygon
	Health = health_component.HealthPoints
	if isHolding <= 1:
		holding_one.show()
		holding_two.hide()
		shadow_h_1.show()
		shadow_h_2.hide()
