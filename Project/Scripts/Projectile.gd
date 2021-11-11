extends Node2D

var sender = null
var move = Vector2(0,0)
var effects
var interact = []
var affect = []
var type = "Projectile"
var has_after = false
onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	position += move*delta#move
	if position.distance_to(player.position) > 800:
		queue_free()
	var areas = $Area2D.get_overlapping_areas()
	if areas:#test if hit another area
		for a in areas:
			if a.get_parent().type in affect:
				a.get_parent().interact(effects,self)
			elif a.get_parent().type in interact:
				a.get_parent().interact(effects,self)
				queue_free()

func add_data(data):#set stats
	if data["time"] != -1:
		$Timer.wait_time = data["time"]
	else:
		$Timer.autostart = false
	effects = data["effects"]
	for n in data["affect"]:
		affect.append(n.input)
	
	for n in data["interact"]:
		interact.append(n.input)
	
	modulate = Color(data.color)
	if get_node("Light2D") and data.color != "ffffff":
		$Light2D.color = Color(data.color)

	
func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Wall" and "Wall" in interact:
		for e in effects:
			if e.type == "after_projectile":
				get_node("/root/World").create_projectile(position,e.input)
		queue_free()
