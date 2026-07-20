extends Area2D
class_name HitboxComponent

@export var selfHurtbox: HurtboxComponent
@export var Entity:Node2D

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area.get_parent().get_parent() is not PlayerClass:
			if area != selfHurtbox:
				#attack(area) will allow infighting
				pass
		elif area.get_parent().get_parent() is PlayerClass: attack(area)


func attack(area: Area2D):
	var NewAttack = Attack.new()
	NewAttack.attack_damage = Entity.AttackStrength
	NewAttack.knockback_force = Entity.KBstrengh
	NewAttack.attack_position = global_position
	NewAttack.hit_cooldown = Entity.AttackCooldown
	if area.get_parent().get_parent() is PlayerClass:
		var playerRef:PlayerClass = area.get_parent().get_parent()
		if playerRef.isOnIce:
			playerRef.velocity += (Entity.velocity.normalized()*NewAttack.knockback_force*4)*10
		else:
			playerRef.velocity += (Vector2(Entity.KBstrengh*300,Entity.KBstrengh*300)*Entity.velocity.normalized().round())
	if area.get_parent().get_parent() is enemyClass:
		var enemyRef = area.get_parent().get_parent()
		enemyRef.velocity += (Vector2(Entity.KBstrengh,Entity.KBstrengh)*Entity.velocity.normalized().round())
	area.damage(NewAttack)
	area.get_parent().get_parent().move_and_slide()
