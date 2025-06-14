extends Area2D
class_name projectile

@onready var projectile_gone = $ProjectileGone
@onready var projectile_trail: CPUParticles2D = $ProjectileTrail
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var distanceTraveled = 0
@export var Speed = 500
@export var RANGE = 100
@export var peircingLevel = 1

const Player = preload("res://scripts/player/Player.gd")
var PlayerIn = Player.new()

func DestroyProjectile(particles:bool, sprite):
	projectile_gone.set_emitting(particles)
	projectile_trail.set_emitting(false)
	collision_shape_2d.set_deferred("set_disabled", true)
	collision_shape_2d.queue_free()
	if sprite != null:
		sprite.hide()
	set_deferred("set_monitorable", false)
	set_deferred("set_monitoring", false)
	ray_cast.set_enabled(false)
	await projectile_gone.finished
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	self.position += direction * Speed * delta
	if distanceTraveled > RANGE:
		queue_free()
