extends Area2D
class_name projectile

##This is a projectile it inherits the Area2D class 

@onready var projectile_gone = $ProjectileGone
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
func DestroyProjectile(particles:bool, sprite):
	projectile_gone.set_emitting(particles)
	projectile_trail.set_emitting(false)
	collision_shape_2d.set_deferred("set_disabled", true)
	collision_shape_2d.queue_free()
	if sprite != null:
		sprite.hide()
	set_deferred("set_monitorable", false)
	set_deferred("set_monitoring", false)
	await projectile_gone.finished
	queue_free()

##Called every frame
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	self.position += direction * Speed * delta
	if distanceTraveled > RANGE:
		queue_free()

##Called every frame
func _process(_delta: float) -> void:
	if self.has_overlapping_bodies():
		for i in self.get_overlapping_bodies():
			if i.is_in_group("World"):
				if goneThrough >= peircingLevel:
					DestroyProjectile(true, visual)
				elif goneThrough <= peircingLevel:
					goneThrough = goneThrough+1
