extends Area2D

const Entity = preload("res://game/entities/Entity.gd")
export(Entity.Team) var team = Entity.Team.Player
export(float) var damage = 0.5

var bodies = []

func _ready():
	# Await Level start
	if SignalMngr.connect("level_started", self, "_on_level_started") != OK:
		D.e("DamageArea", ["Signal level_started is already connected"])
	

func _on_level_started(_level):
	bodies = []
	
func _on_DamageArea_body_entered(body):
	if body is Entity and body.team == team:
		bodies.append(body)
func _on_DamageArea_body_exited(body):
	if body is Entity and body.team == team:
		bodies.erase(body)

func _process(_delta):
	for body in bodies:
		body.deal_damage(damage)
