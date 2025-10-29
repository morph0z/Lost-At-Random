extends Area2D
class_name projectile

##This is a projectile it inherits the Area2D class 

const Projectile_Gone = preload("res://scenes/particles/ProjectileGone_prt.tscn")
@onready var projectile_trail: CPUParticles2D = $ProjectileTrail
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
##The speed of the projectile
@export var Speed = 500
##How far the projectile can fly
@export var RANGE = 100
##How many walls or enemys the projectile can go throungh
@export var peircingLevel = 0
##The visual indicator of the projectile
@export var visual: Node2D
##The amount of things the projectile has gone through
var goneThrough = 0
##How far the projectile has gone
var distanceTraveled = 0

const Player = preload("res://scripts/player/Player.gd")
var PlayerIn = Player.new()

##When called this function will destroy the projectile
func DestroyProjectile():
	var particles:CPUParticles2D = createParticles()
	particles.emitting = true
	queue_free()

##Called every frame
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	self.position += direction * Speed * delta
	#distanceTraveled += 1
	if distanceTraveled > RANGE:
		queue_free()

##Called every frame
func _process(_delta: float) -> void:
	if self.has_overlapping_bodies():
		for i in self.get_overlapping_bodies():
			if i.is_in_group("World"):
				if goneThrough == peircingLevel:
					DestroyProjectile()
				elif goneThrough < peircingLevel:
					if body_exited:
						goneThrough = goneThrough+1

##Creates particles at the bullets position
func createParticles() -> CPUParticles2D:
	var projGonePrt = Projectile_Gone.instantiate()
	projGonePrt.position = position
	get_tree().get_root().add_child(projGonePrt)
	return projGonePrt
