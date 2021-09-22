extends Sprite

export(Resource) var data
onready var id = int(name)

var mouse_in = false
onready var tool_tip = get_node("../../Tool_tip")

func _on_Button_button_up():
	get_parent().get_parent().check_point(self)

func _on_Button_mouse_entered():#open toot_tip
	if data:
		for s in tool_tip.get_node("Stats").get_children():
			s.queue_free()
		
		mouse_in = true
		tool_tip.get_node("Name").text = data.name
		tool_tip.get_node("Description").text = data.description
		tool_tip.visible = true
		if data.special:
			match data.special.type:
				"Action":
					tool_tip.get_node("Sprite").texture = data.special.icon
		for stat in data.stats:
			var l = Label.new()
			l.text = ["Damage","Heath","Defence","Speed","Crit","Crit Dam","Mana","Mana regen"][stat.type] + [" + "," +% "][stat.change] + str(stat.amount)
			tool_tip.get_node("Stats").add_child(l)

func _on_Button_mouse_exited():
	mouse_in = false
	tool_tip.visible = false

func _process(delta):
	if mouse_in:
		tool_tip.global_position = get_viewport().get_mouse_position() + Vector2(0,32)
	
