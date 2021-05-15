extends Node2D

var file_port = "res://Resoure_editer2.1/"
var resoure_scripts = "res://Resource script/"

onready var button_scene = load(file_port + "Button.tscn")
onready var useable_scene = load(file_port +"Useable.tscn")
onready var link_scene = load(file_port +"Link.tscn")

var all_files = []
var has_link

func _ready():
	get_files(resoure_scripts,all_files)
	for f in all_files:
		create_button(f)
	$CanvasLayer/Load.connect("file_selected",self,"load_res")
	$CanvasLayer/Save.connect("file_selected",self,"save_res")

func create_button(file_data):
	var button_instance = button_scene.instance()
	button_instance.file_data = file_data
	$CanvasLayer/Buttons/Holder.add_child(button_instance)
	
func get_files(path,list_add):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	var file_name = dir.get_next()
	while file_name != "":
		print("Found file: " + file_name)
		var n = load(path + file_name)
		n.resource_name = file_name
		
		var r = Resource.new()
		r.set_script(n)
		if not r.get("dont_show"):
			all_files.append(n)

		file_name = dir.get_next()

func create_useable(file_data):
	var useable_instance = useable_scene.instance()
	useable_instance.resoure = file_data.duplicate()
	useable_instance.get_node("Label").text = file_data.get_script().resource_name
	useable_instance.drag = true
	$Use.add_child(useable_instance)
	return useable_instance

func create_link(control):
	var link_instance = link_scene.instance()
	link_instance.control = control
	control.link = link_instance
	has_link = link_instance
	control.add_child(link_instance)
	return link_instance
	
func _on_Done_button_up():
	$CanvasLayer/Save.popup()
	
func load_res(file):
	create_useable(load(file))

func save_res(file):
	var n = $Use.get_child(0).resoure
	var dir = Directory.new()
	print(dir.remove(file))
	yield(get_tree(),"idle_frame")
	print(ResourceSaver.save(file,n))

func _on_Button_button_up():
	$CanvasLayer/Load.popup()

func _on_Button_Unique_button_up():
	$CanvasLayer/Load.popup()
