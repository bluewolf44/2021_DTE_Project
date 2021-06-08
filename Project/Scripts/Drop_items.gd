extends Node2D
var data
var type = "drop_item"

func _on_Button_button_down():
	if get_parent().get_parent().get_node("Player").position.distance_to(position) <= 100:
		PlayerData.add_item(data)
		if get_parent().get_parent().get_node("Player/CanvasLayer/Inventory").visible:
			get_parent().get_parent().get_node("Player").update_inv()
		queue_free()
