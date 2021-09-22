extends Node2D
var data
var type = "drop_item"

func _ready():#changes the effect of the item
	$AnimationPlayer.play(["","Common","Uncommon","rare","Mythical","legendary"][data.rare])

func _on_Button_button_down():#test if in 10 distance then add to invitroy 
	if get_parent().get_parent().get_node("Player").position.distance_to(position) <= 100:
		PlayerData.add_item(data)
		if get_parent().get_parent().get_node("Player/CanvasLayer/Inventory").visible:
			get_parent().get_parent().get_node("Player").update_inv()
		queue_free()
