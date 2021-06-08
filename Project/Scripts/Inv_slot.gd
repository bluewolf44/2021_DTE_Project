extends Control

var data

func _on_Button_button_up():
	if get_parent().get_parent().get_parent().get_node("Move").data and data:
		var new_data = get_parent().get_parent().get_parent().get_node("Move").data
		if new_data.sprite:
			$icon.texture = new_data.sprite
		$icon.modulate = Color(0,1,0)
		PlayerData.remove_item(data)
		get_parent().get_parent().get_parent().get_parent().move_item(data)
		PlayerData.inventory[int(name)] = new_data
		data = new_data
	
	elif get_parent().get_parent().get_parent().get_node("Move").data:
		data = get_parent().get_parent().get_parent().get_node("Move").data
		if data.sprite:
			$icon.texture = data.sprite
		$icon.modulate = Color(0,1,0)
		PlayerData.remove_item(data)
		PlayerData.inventory[int(name)] = data
		get_parent().get_parent().get_parent().get_parent().reset_move()
	
	elif data:
		$icon.texture = load("res://icon.png")
		$icon.modulate = Color(1,1,1)
		get_parent().get_parent().get_parent().get_parent().move_item(data)
		data = null
		PlayerData.remove_item(data)

func _on_Slot_mouse_entered():
	if data:
		get_parent().get_parent().get_parent().get_parent().show_info(self,data)
