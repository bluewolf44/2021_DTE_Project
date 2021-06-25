extends Control

func _on_Button_button_down():
	if get_parent().get_parent().get_parent().other_action:
		get_parent().get_parent().get_parent().held_action = int(name)
