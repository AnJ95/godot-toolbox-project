extends Area2D

const Entity = preload("res://scenes/entities/Entity.gd")
export(Entity.Team) var team = Entity.Team.Player
export(float) var damage = 0.5

func _on_DamageArea_body_entered(body):
	if body is Entity and body.team == team:
		body.deal_damage(damage)
