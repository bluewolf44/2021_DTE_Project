extends Node2D

var amount = 0
var type = "Gold"

func _on_Area2D_body_entered(body):#test if player touch gold
	if body.get("type") == "Player":
		get_parent().get_parent().create_text(str(amount),position,Color("ecf01a"))
		PlayerData.add_gold(amount)#add gold to player
		queue_free()
