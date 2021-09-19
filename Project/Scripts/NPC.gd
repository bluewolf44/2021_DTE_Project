extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Q"):
		if $Area2D.overlaps_area(get_node("../../Player/Area2D")):
			print("do stuff")
