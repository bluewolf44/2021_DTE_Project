extends Node2D

var move = Vector2(0,0)
var effects
var interact

func _process(delta):
	position += move*delta

func _on_Area2D_area_entered(area):
	pass # Replace with function body.

func add_data(data):
	if data["time"] != -1:
		$Timer.wait_time = data["time"]
	effects = data["effects"]
	interact = data["interact"]
	$Spell_attack.texture = data["texture"]
	
func _on_Timer_timeout():
	queue_free()
