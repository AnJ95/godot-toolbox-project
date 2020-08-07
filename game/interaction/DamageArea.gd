extends Area2D

const Entity = preload("res://game/entities/Entity.gd")
export(Entity.Team) var team = Entity.Team.Player
export(float) var damage = 0.5

var bodies = []

func _ready():
	# Await Level start
	SignalMngr.connect("level_started", self, "_on_level_started")

func _on_level_started(_level):
	bodies = []
	
func _on_DamageArea_body_entered(body):
	if body is Entity and body.team == team:
		bodies.append(body)
func _on_DamageArea_body_exited(body):
	if body is Entity and body.team == team:
		bodies.erase(body)

func _process(delta):
	for body in bodies:
		body.deal_damage(damage)
