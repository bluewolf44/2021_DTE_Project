extends Control

var type
var link

func _on_TextEdit_text_changed():
	var input
	match type:
		"int":
			if int($TextEdit.text) == 0 and not $TextEdit.text in ["0",""]:
				$TextEdit.text = "0"
				print($TextEdit.text)
			input = int($TextEdit.text)
		"str":
			input = $TextEdit.text
		"float":
			if float($TextEdit.text) == 0 and not $TextEdit.text in ["0",""]:
				$TextEdit.text = "0.0"
			elif $TextEdit.text.find_last(".") == -1 and not $TextEdit.text in ["0",""]:
				$TextEdit.text += ".0"
			input = float($TextEdit.text)
		"vec2":
			for l in [$X,$Y]:
				if int(l.text) == 0 and not l.text in ["0",""]:
					l.text = "0"
			input = Vector2(int($X.text),int($Y.text))
	get_parent().get_parent().get_parent().resoure[$Label.text] = input



func _ready():
	$MenuButton.get_popup().connect("id_pressed",self,"check_box_id_pressed")
	$FileDialog.connect("file_selected",self,"load_file")
	$FileDialog.current_dir = "res://Resources/"

func check_box_id_pressed(id):
	if type in ["create","create_one"]:
		if id == 0:
			get_node("/root/Resoure_editer").create_link(self)
		else:
			var n = Resource.new()
			var scrit = load(get_node("/root/Resoure_editer").resoure_scripts + $MenuButton.get_popup().get_item_text(id)+ ".gd")
			n.set_script(scrit)
			get_node("/root/Resoure_editer").create_link(self)
			link.find = false
			get_node("/root/Resoure_editer").has_link = null
			n = get_node("/root/Resoure_editer").create_useable(n)
			link.node2d = n
			n.link = link
			n.get_parent().remove_child(n)
			add_child(n)
			var k = [n.resoure,get_parent().get_parent().get_parent().resoure]
			if type == "create_one":
				get_parent().get_parent().get_parent().resoure[$Label.text] = n.resoure
			else:
				get_parent().get_parent().get_parent().resoure[$Label.text].append(n.resoure)
			
		if type == "create_one":
			$MenuButton.disabled = true
	else:
		$MenuButton.text = $MenuButton.get_popup().get_item_text(id)
		get_parent().get_parent().get_parent().resoure[$Label.text] = id
	
func _on_Button_button_down():
	match type:
		"tex","text":
			$FileDialog.popup()
		_:
			get_node("/root/Resoure_editer").create_link(self)
			if type == "obj":
				$Button.disabled = true
		
func add_obj(d):
	var j = Vector2(0,-50)
	var w = []
	for data in d:
		get_node("/root/Resoure_editer").create_link(self)
		link.find = false
		get_node("/root/Resoure_editer").has_link = null
		var n = get_node("/root/Resoure_editer").create_useable(data)
		link.node2d = n
		n.link = link
		n.get_parent().remove_child(n)
		add_child(n)
		n.position = Vector2(250,0) + j
		n.drag = false
		link.re_draw()
		j += Vector2(0,50)
		if type == "create":
			w.append(n.resoure)
		else:
			get_parent().get_parent().get_parent().resoure[$Label.text] = n.resoure
	
	if w:
		get_parent().get_parent().get_parent().resoure[$Label.text] = w
	
func load_file(file):
	match type:
		"tex":
			var n = load(file)
			get_parent().get_parent().get_parent().resoure[$Label.text] = n
			$Sprite.texture = n
			$Sprite.scale = Vector2(64/n.get_size().x,64/n.get_size().y)
		"text":
			get_parent().get_parent().get_parent().resoure[$Label.text] = file
			$Scroll_text/Text.text = file

func _on_CheckBox_button_down():
	get_parent().get_parent().get_parent().resoure[$Label.text] = !get_parent().get_parent().get_parent().resoure[$Label.text]


