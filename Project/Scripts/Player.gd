extends KinematicBody2D

var speed = 300

func _process(delta):
	var move = Vector2(
		Input.get_action_strength("Move_Right")-Input.get_action_strength("Move_Left"),
		Input.get_action_strength("Move_Down")-Input.get_action_strength("Move_Up")
		)
	move_and_slide(move.normalized()*speed)
	if move:
		$AnimationTree.get("parameters/playback").travel("Run")
		$AnimationTree.set("parameters/Stand/blend_position",move)
		$AnimationTree.set("parameters/Run/blend_position",move)
	else:
		$AnimationTree.get("parameters/playback").travel("Stand")
