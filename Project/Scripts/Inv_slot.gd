extends Control

var data
onready var player = get_parent().get_parent().get_parent().get_parent()
onready var move = get_parent().get_parent().get_parent().get_node("Move")


func _on_Button_button_up():
	if move.data and data:
		var new_data = move.data
		if new_data.sprite:
			$icon.texture = new_data.sprite
		$icon.modulate = Color(0,1,0)
		PlayerData.remove_item(data)
		player.move_item(data)
		PlayerData.inventory[int(name)] = new_data
		data = new_data
	
	elif move.data:
		data = move.data
		if data.sprite:
			$icon.texture = data.sprite
		$icon.modulate = Color(0,1,0)
		PlayerData.remove_item(data)
		PlayerData.inventory[int(name)] = data
		player.reset_move()
		player.show_info(self,data)
	
	elif data:
		$icon.texture = load("res://icon.png")
		$icon.modulate = Color(1,1,1)
		player.move_item(data)
		data = null
		PlayerData.remove_item(data)

func _on_Slot_mouse_entered():
	if data:
		player.show_info(self,data)

func _on_Slot_mouse_exited():
	player.get_node("CanvasLayer/Inventory/Info").visible = false