extends Node2D

onready var currnet_point = $Points/"0"
onready var path = [$Points/"0"]
onready var points = PlayerData.lvl

var held = false
var base_place = Vector2(0,0)

func check_point(node):
	if node in path or points <= 0:
		return
	for p in $Paths.get_children():#if next point beside
		if p.id1 == currnet_point.id or p.id2 == currnet_point.id:
			if p.id1 == node.id or p.id2 == node.id:
				path.append(node)
				currnet_point = node
				node.modulate = Color("2e3a08")
				p.modulate = Color("2e3a08")
				points -= 1
				$CanvasModulate/Points.text = str(points)
				break
			else:
				print("die")

func done_skill():#go back to world 
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

func _on_Restart_button_up():#reset the points
	currnet_point = $Points/"0"
	path = [$Points/"0"]
	points = PlayerData.lvl
	for p in $Points.get_children()+$Paths.get_children():
		p.modulate = Color(1,1,1)
	$Points/"0".modulate = Color("2e3a08")
	$CanvasModulate/Points.text = str(points)

func _process(delta):#move the camera
	var move =  Vector2(
		Input.get_action_strength("Move_Left")-Input.get_action_strength("Move_Right"),
		Input.get_action_strength("Move_Up")-Input.get_action_strength("Move_Down")
	)
	position += move*delta*300
	if position.x > base_place.x + 500:
		position.x = base_place.x + 500
	if position.x < base_place.x - 500:
		position.x = base_place.x - 500
	if position.y < base_place.y - 500:
		position.y = base_place.y - 500
	if position.y > base_place.y + 500:
		position.y = base_place.y + 500
