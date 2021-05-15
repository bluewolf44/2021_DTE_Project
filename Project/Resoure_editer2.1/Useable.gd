extends Node2D

var resoure
var drag = false
var link
onready var mouse_place = $MarginContainer.rect_size/2

func _ready():
	make_inputs(resoure)

func make_inputs(file_data):
	yield(get_tree(),"idle_frame")
	for property in file_data.create_inputs:
		var data = file_data[property["name"]]
		match property["input"]:
			"enum":
				var n = []
				for k in file_data[property["other"]]:
					n.append(k)
				data = [n,n[data]]
#			"array":
#				if data != []:
#					data = file_data[property["name"]]
			"create","create_one":
				data = [property["other"],data]
					
		create_input(property["name"],property["input"],data)

func _process(delta):
	if drag:
		global_position = get_global_mouse_position()-mouse_place
		if link:
			link.re_draw()

func create_input(text,type,data=null):
	var input_instance = load("res://Resoure_editer2.1/Input.tscn").instance()
	input_instance.type = type
	input_instance.get_node("Label").text = str(text)
	
	match type:
		"enum":
			create_check_box(input_instance.get_node("MenuButton").get_popup(),data[0])
			input_instance.get_node("MenuButton").text = data[1]
			input_instance.get_node("MenuButton").visible = true

		"create","create_one":
			create_check_box(input_instance.get_node("MenuButton").get_popup(),["Add"] + data[0])
			input_instance.get_node("MenuButton").visible = true
			input_instance.get_node("MenuButton").text = "Add"
			
			if data[1]:
				$MarginContainer/VBoxContainer.add_child(input_instance)
				if type == "create_one":
					input_instance.add_obj([data[1]])
				else:
					input_instance.add_obj(data[1])
				input_instance.get_node("MenuButton").text = "Add"
				return
		"tex":
			input_instance.get_node("ColorRect").rect_size = Vector2(214,69)
			input_instance.get_node("Button").rect_position = Vector2(49,30)
			input_instance.rect_size = Vector2(220,72)
			input_instance.rect_min_size = Vector2(220,72)
			input_instance.get_node("Label").rect_position.y = 32
			input_instance.get_node("Sprite").visible = true
			input_instance.get_node("Button").visible = true
			if data:
				input_instance.get_node("Sprite").texture = data
		"bool":
			input_instance.get_node("CheckBox").visible = true
			input_instance.get_node("CheckBox").pressed = data
		"vec2":
			input_instance.get_node("X").visible = true
			input_instance.get_node("X").text = str(data.x)
			input_instance.get_node("Y").visible = true
			input_instance.get_node("Y").text =  str(data.y)
		"text":
			input_instance.get_node("Scroll_text/Text").text = data
			input_instance.get_node("Button").visible = true
			input_instance.get_node("ColorRect").rect_size = Vector2(214,69)
			input_instance.rect_min_size = Vector2(220,72)
			input_instance.rect_size = Vector2(220,72)
			input_instance.get_node("Scroll_text").visible = true
			input_instance.get_node("FileDialog").filters = PoolStringArray(["*txt"])
		_:
			input_instance.get_node("TextEdit").text = str(data)
			input_instance.get_node("TextEdit").visible = true
	
	for node in input_instance.get_children():
		if not node.visible and not node is FileDialog:
			node.queue_free()
	$MarginContainer/VBoxContainer.add_child(input_instance)

func create_check_box(check_box,data):
	var index = 0
	for l in data:
		check_box.add_check_item(l)
		check_box.set_item_as_checkable(index,true)
		index += 1

func _on_Delete_button_up():
	if link:
		if link.control.type == "create":
			link.control.get_parent().get_parent().get_parent().resoure[link.control.get_node("Label").text].erase(resoure)
		elif link.control.type == "create_one":
			link.control.get_parent().get_parent().get_parent().resoure[link.control.get_node("Label").text] = null
		
		if link.control.type == "create_one":
			link.control.get_node("MenuButton").disabled = false
		link.queue_free()
	queue_free()

func _on_Move_button_down():
	var l = get_node("/root/Resoure_editer").has_link
	if l and get_parent().name == "Use":
		
		var n = l.get_parent()
		while n.name != "Use":
			if self == n:
				print("nan")
				return
			n = n.get_parent()
		
		get_node("/root/Resoure_editer").has_link = null
		get_parent().remove_child(self)
		l.control.add_child(self)
		global_position = position 
		l.find = false
		link = l
		l.node2d = self
		if l.control.type == "create_one":
			l.control.get_parent().get_parent().get_parent().resoure[l.control.get_node("Label").text] = resoure
		else:
			l.control.get_parent().get_parent().get_parent().resoure[l.control.get_node("Label").text] += [resoure]
	else:
		mouse_place = get_local_mouse_position()
		if mouse_place.x < 0:
			mouse_place.x = 0
		if mouse_place.y < 0:
			mouse_place.y = 0
		drag = !drag

func _on_Hide_button_up():
	for n in $MarginContainer/VBoxContainer.get_children():
		if n.get_node("Label").text != "name":
			n.visible = !n.visible
	$MarginContainer.set_size(Vector2(0,0))
	$Delete.visible = !$Delete.visible
