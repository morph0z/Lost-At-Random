extends CharacterBody2D

@onready var playerSeen = $"../../Player"
@onready var animation_player = $AnimationPlayer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@onready var health_component: HealthComponent = $Components/HealthComponent
var attacking = false

#attributes of the enemy
@export var SPEED = 60.0
@export var KBstrengh: float = 3
@export var AttackCooldown: float
@export var AttackStrength: int = 10
#var Health
var target


func _ready():
	animation_player.play("RESET")

func _physics_process(_delta):
	if not playerSeen == null:
		#moves enemy while player is in see area
		#set_velocity(position.direction_to(playerSeen.position) * SPEED)
		var dir = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * SPEED
		#look_at(playerSeen.global_position)
	move_and_slide()

func makePath() -> void:
	if playerSeen.is_queued_for_deletion() == false:
		navigation_agent_2d.target_position = playerSeen.global_position

func _on_hurtbox_component_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var attack = Attack.new()
		attacking = true
		attack.attack_damage = AttackStrength
		attack.knockback_force = KBstrengh
		attack.attack_position = global_position
		attack.hit_cooldown = AttackCooldown
		area.get_parent().get_parent().velocity = velocity*attack.knockback_force*4 
		area.damage(attack)
		area.get_parent().get_parent().set_velocity(Vector2(KBstrengh*(1000),KBstrengh*(1000))*velocity.normalized().round())
		area.get_parent().get_parent().move_and_slide()
		print()


func _on_timer_timeout() -> void:
	makePath()
