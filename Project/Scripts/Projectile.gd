extends Node2D

var move = Vector2(0,0)
var effects
var interact
var type = "projectile"
onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	position += move*delta
	if position.distance_to(player.position) > 400:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.get_parent().type in interact:
		area.get_parent().interact(effects)
		queue_free()

func add_data(data):
	if data["time"] != -1:
		$Timer.wait_time = data["time"]
	effects = data["effects"]
	interact = data["interact"]
	$Attacks.play(data["sprite"])
	$Area2D/CollisionShape2D.position = data["collionShape"]["position"]
	$Area2D/CollisionShape2D.shape.extents = data["collionShape"]["size"]
	
func _on_Timer_timeout():
	queue_free()
