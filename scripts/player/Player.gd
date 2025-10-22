extends CharacterBody2D
class_name PlayerClass

#Child Nodes
@onready var sprint_dust = $Particles/SprintDust
@onready var player_got_hit_prt = $Particles/PlayerGotHitPrt
@onready var player_death_prt: CPUParticles2D = $Particles/PlayerDeathPrt
@onready var animation_player = $AnimationPlayer
@onready var items = $Items
@onready var camera = $Camera
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var dash_timer: Timer = $DashTimer
@onready var player_dash_prt: CPUParticles2D = $Particles/PlayerDashPrt
@onready var player_ui: Control = $CanvasLayer/PlayerUI

#State Machine
@export var state_machine : LimboHSM

#States
@onready var idle_state: LimboState = $LimboHSM/Idle
@onready var walking_state: LimboState = $LimboHSM/Walking
@onready var sprinting_state: LimboState = $LimboHSM/Sprinting
@onready var dead_state: LimboState = $LimboHSM/Dead

#--------------------------------------------------------------------------------

signal itemPicked 

#componets
@export var health_component:HealthComponent
@onready var stamina_componet: StaminaComponent = $Componets/StaminaComponet

#-------------------------------------------------------------------------------

#settings
var joyStickSense = 0.5

#-------------------------------------------------------------------------------

#atrributes
@export_group("Attributes")
@export var walkSpeed:float = 100.0
@export var sprintSpeed:float = 200.0
@export var Acceleration:float = 50.0
var SPEED = walkSpeed
@export var attackStrengthMultiplier:float = 1
@export var swordStrengthMultiplier:float = 1
@export var scytheStrengthMultiplier:float = 1
@export var bowStrengthMultiplier:float = 1
@export var gunStrengthMultiplier:float = 1
#var EnemyStrenghtMultiplyer = 1
var EntityHealth

#-------------------------------------------------------------------------------

#bools
var slowmotimer = null
var isOnIce = true
var isHolding = 0

#-------------------------------------------------------------------------------

func _ready():
	_initialize_state_machine()
	animation_player.play("RESET")
	health_component.HealthPoints = 100
	
#-------------------------------------------------------------------------------

func _initialize_state_machine():
	state_machine.initial_state = idle_state
	state_machine.initialize(self)
	state_machine.set_active(true)

#-------------------------------------------------------------------------------

func _input(event):
				
	#checks if player is dead duh
	if !health_component.isDead:
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
			sprint(true)
		elif Input.is_action_just_released("SprintShift"):
			sprint(false)
		if Input.is_action_just_pressed("DashCtrl"):
			dash(3)
		
	#ITEM DROPPING SYSTEM
	if Input.is_action_pressed("Drop"):
		#checks if the player has one item or not
		if items.get_children().size() >= 1:
			items.get_child(0).animation_player.play("Drop")
			if items.get_children().size() > 1:
				items.get_child(1).animation_player.play("heldF")
			await get_tree().create_timer(items.get_child(0).animation_player.current_animation_length).timeout
			if items.get_children().size() > 0:
				items.get_child(0).queue_free()
			isHolding = isHolding-1
			sprite.play("HoldingOne")

#-------------------------------------------------------------------------------

func sprint(sprintToggle):
	var canSprint = (sprintToggle) and (stamina_componet.Stamina > 0) and (stamina_componet.canUseStamina)
	if canSprint:
		SPEED = sprintSpeed
		stamina_componet.startStaminaDrain(1, 0.05)
		sprint_dust.get_child(0).set_emitting(sprintToggle)
		state_machine.change_active_state(sprinting_state)
	elif !canSprint:
		setWalking()
		stamina_componet.stopStaminaDrain()
		
#-------------------------------------------------------------------------------

func dash(dashPower):
	var canDash = (dash_timer.time_left == 0) and (stamina_componet.Stamina > 0) and (stamina_componet.canUseStamina)
	if canDash:
		stamina_componet.useStamina(dashPower*5)
		SPEED = (SPEED+(dashPower*100))
		player_dash_prt.emitting = true
		await get_tree().create_timer(0.1).timeout
		player_dash_prt.emitting = false
		SPEED = walkSpeed
		dash_timer.start()

#-------------------------------------------------------------------------------

func _physics_process(_delta):
	if !health_component.isDead:	
		#this is for movement 
		var direction = Input.get_vector("LeftA","RightD","UpW","DownS")
		if direction != Vector2.ZERO:
			if !isOnIce:
				velocity = direction*SPEED
			elif isOnIce:
				velocity += (direction*SPEED)/Acceleration
			if SPEED == walkSpeed:
				state_machine.change_active_state(walking_state)
			elif SPEED == sprintSpeed:
				state_machine.change_active_state(sprinting_state)			
		elif direction == Vector2.ZERO:
			state_machine.change_active_state(idle_state)
			if !isOnIce:
				velocity = Vector2.ZERO
			elif isOnIce:
				velocity.x = move_toward(velocity.x , 0, _delta*Acceleration)
				velocity.y = move_toward(velocity.y , 0, _delta*Acceleration)
			
		move_and_slide()	
	
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
				#print(isHolding)
				if isHolding == 2:
					sprite.play("HoldingTwo")

#-------------------------------------------------------------------------------

func _process(_delta):
	EntityHealth = health_component.HealthPoints
	#print(state_machine.get_active_state())

	if isHolding <= 1:
		sprite.play("HoldingOne")
	if stamina_componet.Stamina < 0:
		stamina_componet.Stamina = 0

#-------------------------------------------------------------------------------

func setWalking():
	state_machine.change_active_state(walking_state)
	sprint_dust.get_child(0).set_emitting(false)
	SPEED = walkSpeed
