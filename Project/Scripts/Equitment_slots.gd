extends Control

export var type = ""
var id = 0
var data

onready var player = get_parent().get_parent().get_parent().get_parent()
onready var move = get_parent().get_parent().get_parent().get_node("Move")

func _ready():
	id = int(name)
	data = PlayerData.equited.get(id)
	if not data:
		PlayerData.equited[id] = null
	else:
		$Sprite.modulate = data.color
		if data.sprite:
			$Sprite.texture = data.sprite

func _on_Button_button_up():
	if move.data and data and ["Chest","Ring","Legs","Head","Weapon"][move.data.type] == type:
		var new_data = move.data
		if new_data.sprite:
			$Sprite.texture = new_data.sprite
		$Sprite.modulate = new_data.color
		
		PlayerData.equited[id] = new_data
		PlayerData.remove_item(new_data)
		player.move_item(data)
		data = new_data
		PlayerData.update_stats()

	elif move.data and ["Chest","Ring","Legs","Head","Weapon"][move.data.type] == type:
		data = move.data
		if data.sprite:
			$Sprite.texture = data.sprite
		$Sprite.modulate = data.color
		PlayerData.remove_item(data)
		PlayerData.equited[id] = data
		player.reset_move()
		player.show_info(self,data)
		PlayerData.update_stats()
	
	elif data and not move.data :
		$Sprite.texture = load("res://icon.png")
		$Sprite.modulate = Color(0,0,0)
		player.move_item(data)
		data = null
		PlayerData.equited[id] = null
		PlayerData.update_stats()

func _on_Button_mouse_entered():
	if data:
		player.show_info(self,data)

func _on_Button_mouse_exited():
	player.get_node("CanvasLayer/Inventory/Info").visible = false
