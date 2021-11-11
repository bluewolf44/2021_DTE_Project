extends Node2D

var type = "finished"
func _process(delta):
	if Input.is_action_just_pressed("Q"): #when Q got to map with in area
		if $Area2D.overlaps_area(get_node("../../Player/Area2D")):
			get_tree().change_scene("res://Scenes/You_win.tscn")


func _on_Area2D_area_entered(area):
	if get_node("../../Player/Area2D") == area:
		$Label.visible = true

func _on_Area2D_area_exited(area):
	if get_node("../../Player/Area2D") == area:
		$Label.visible = false
