class_name enemyClass extends CharacterBody2D

@onready var playerSeen:PlayerClass
@onready var animation_player = $AnimationPlayer
@onready var target_ray: RayCast2D = $SeeArea/targetRay
@onready var forgeting_timer: Timer = $ForgetingTimer
@onready var wander_timer: Timer = $WanderTimer

@onready var health_component: HealthComponent = $Components/HealthComponent
var attacking = false

var randBool:Array = [true,false]

#attributes of the enemy
@export var SPEED = 60.0
@export var KBstrengh: float = 3
@export var AttackCooldown: float
@export var AttackStrength: int = 10
@export var ViewingDistance: int = 100 
@onready var dir:Vector2
var newRandomDir:Vector2
#var Health

#states
@onready var wandering:bool = false
@onready var chasing:bool = false

func _ready():
	animation_player.play("RESET")
	wander(80)

func _physics_process(delta):
	if wandering:
		velocity = (newRandomDir)*SPEED*delta
	if chasing:
		velocity = position.direction_to(playerSeen.position) * SPEED
		target_ray.target_position = (position.direction_to(playerSeen.position))*ViewingDistance
		if (target_ray.get_collider() is not PlayerClass) and (target_ray.is_colliding()):
			wandering = true
			chasing = false
		
	move_and_slide()

func chase():
	chasing = true
	wandering = false

func _on_see_area_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is PlayerClass:
		playerSeen = area.get_parent().get_parent()
		chase()

func _on_see_area_area_exited(area: Area2D) -> void:
	if area.get_parent().get_parent() is PlayerClass:
		wander(80)

func _on_forgeting_timer_timeout() -> void:
	velocity = Vector2.ZERO

func _on_wander_timer_timeout() -> void:
	var shouldWait = randBool.pick_random()
	if wandering:
		if shouldWait == false:
			newRandomDir = Vector2(randf_range(-100,100),randf_range(-20,20))
		if shouldWait == true:
			newRandomDir = Vector2.ZERO

func wander(speed:float):
	wander_timer.start(1)
	wandering = true
	chasing = false
	SPEED = speed
