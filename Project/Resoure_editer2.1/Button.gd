extends Button

var file_data

func _ready():
	text = file_data.resource_name

func _on_Button_button_up():
	var n = Resource.new()
	n.set_script(file_data)
	get_node("/root/Resoure_editer").create_useable(n)
