extends Label

func _process(delta):
	rect_position += Vector2(0,-70)*delta

func _on_Timer_timeout():
	queue_free()
