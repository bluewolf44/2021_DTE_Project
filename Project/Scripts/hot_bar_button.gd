extends Control

func _on_Button_button_down():
	if get_parent().get_parent().get_parent().action_hold.size() > int(name):
		if name != "10":
			get_parent().get_parent().get_parent().held_action = int(name)
		else:
			get_parent().get_parent().get_parent().held_action = 0
		get_parent().get_parent().get_parent().start_attack()
