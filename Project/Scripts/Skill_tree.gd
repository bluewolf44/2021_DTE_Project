extends Node

onready var currnet_point = $Points/"0"
onready var path = [$Points/"0"]
onready var points = PlayerData.lvl

func check_point(node):
	if node in path or points <= 0:
		return
	for p in $Paths.get_children():
		if p.id1 == currnet_point.id or p.id2 == currnet_point.id:
			if p.id1 == node.id or p.id2 == node.id:
				path.append(node)
				currnet_point = node
				node.modulate = Color("2e3a08")
				p.modulate = Color("2e3a08")
				points -= 1
				break

func _on_Done_button_up():
	PlayerData.skill_stats = []
	PlayerData.action_hold = [load("res://Resoures/Fire_ball2.tres")]
	for d in path:
		if d.data:
			if d.data.special:
				match d.data.special.type:
					"Action":
						PlayerData.action_hold.append(d.data.special)
			for s in d.data.stats:
				PlayerData.skill_stats.append(s)
				PlayerData.update_stats()
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_Restart_button_up():
	currnet_point = $Points/"0"
	path = [$Points/"0"]
	points = PlayerData.lvl
	for p in $Points.get_children()+$Paths.get_children():
		p.modulate = Color(1,1,1)
	$Points/"0".modulate = Color("2e3a08")
