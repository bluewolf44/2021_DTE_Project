extends Sprite

export var type = ""
var data

onready var player = get_parent().get_parent().get_parent().get_parent()
onready var move = get_parent().get_parent().get_parent().get_node("Move")

func _ready():
	data = PlayerData.equited.get(type)
	if not data:
		 PlayerData.equited[type] = null

func _on_Button_button_up():
	if move.data and data:
		var new_data = move.data
		PlayerData.equited[type] = new_data
		PlayerData.remove_item(new_data)
		player.move_item(data)
		data = new_data
		
	elif move.data:
		pass
	
	elif data:
		player.move_item(data)
		PlayerData.equited[type] = null
		data = null

func _on_Button_mouse_entered():
	if data:
		player.show_info(self,data)


func _on_Button_mouse_exited():
	player.get_node("CanvasLayer/Inventory/Info").visible = false
