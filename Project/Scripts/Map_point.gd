extends Node2D

export(Resource) var data
onready var info = get_node("../../Info")

func _on_Button_button_up():
	PlayerData.go_to(data,int(name))#go to map

func _on_Button_mouse_entered():
	info.visible = true
	info.rect_position = position + Vector2(-48,32)
	info.get_node("Name").text = data.name
	for n in info.get_node("Stats").get_children():
		n.queue_free()
	var l = Label.new()
	l.text = "Min level:"+str(data.min_level)
	info.get_node("Stats").add_child(l)
	l = Label.new()
	l.text = "Max level:"+str(data.max_level)
	info.get_node("Stats").add_child(l)
	if data.extra:
		l = Label.new()
		l.text = "Extra:Finish"
		info.get_node("Stats").add_child(l)

func _on_Button_mouse_exited():
	info.visible = false
