extends Camera2D

var speed = 1200

func _process(delta):
	var move = Vector2(
		Input.get_action_strength("Move_Right")-Input.get_action_strength("Move_Left"),
		Input.get_action_strength("Move_Down")-Input.get_action_strength("Move_Up")
		)
	position += move*speed*delta*zoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and zoom.x > 0.5:
			zoom -= Vector2(0.1,0.1)
		elif event.button_index == BUTTON_WHEEL_DOWN and zoom.x <= 2.5:
			zoom += Vector2(0.1,0.1)
