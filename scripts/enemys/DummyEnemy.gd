extends CharacterBody2D

@onready var playerSeen = $"../../Player"
@onready var animation_player = $AnimationPlayer

@onready var health_component: HealthComponent = $Components/HealthComponent
var attacking = false

#attributes of the enemy
@export var SPEED = 60.0
@export var KBstrengh: float = 3
@export var AttackCooldown: float
@export var AttackStrength: int
var EntityHealth
var target


func _ready():
	animation_player.play("RESET")

func _physics_process(_delta):
	move_and_slide()

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
