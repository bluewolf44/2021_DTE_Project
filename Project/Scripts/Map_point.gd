extends Node2D

export(Resource) var data

func _on_Button_button_up():
	PlayerData.go_to(data)
