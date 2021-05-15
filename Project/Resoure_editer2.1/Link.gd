extends Node2D

var node2d
var control
var find = true

func re_draw(n=true):
	var end1
	var end2 = Vector2(control.rect_size.x,control.rect_size.y/2)
	if n:
		end1 = node2d.position+Vector2(65,0)
		look_at(node2d.global_position + Vector2(65,0))
	else:
		end1 = get_global_mouse_position() - global_position + end2
		look_at(get_global_mouse_position())
	position = end2
	position = position.move_toward(end1,3)
	scale.y = (end1.distance_to(end2))-3
	rotation_degrees -= 90

func _process(delta):
	if find:
		if Input.is_action_just_released("RMB"):
			if find:
				if control.get_node("Button"):
					control.get_node("Button").disabled = false
				elif control.get_node("MenuButton"):
					control.get_node("MenuButton").disabled = false
				queue_free()
		re_draw(false)
