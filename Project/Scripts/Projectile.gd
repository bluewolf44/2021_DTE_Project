extends Node2D

var move = Vector2(0,0)
var effects
var interact = []
var affect = []
var type = "Projectile"
onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	position += move*delta
	if position.distance_to(player.position) > 400:
		queue_free()
	var areas = $Area2D.get_overlapping_areas()
	if areas:
		for a in areas:
			if a.get_parent().type in affect:
				a.get_parent().interact(effects)
			elif a.get_parent().type in interact:
				a.get_parent().interact(effects)
				queue_free()

func add_data(data):
	if data["time"] != -1:
		$Timer.wait_time = data["time"]
	else:
		$Timer.autostart = false
	effects = data["effects"]
	for n in data["affect"]:
		affect.append(n.input)
	
	for n in data["interact"]:
		interact.append(n.input)
		
	$Attacks.play(data["sprite"])
	
func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Wall" and "Wall" in interact:
		queue_free()
