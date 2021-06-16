extends Node

onready var enemy_scenes = ["Goblin","Minotaur"]
onready var projectile_scene = load("res://Scenes/Projectile.tscn")

func _ready():
	randomize()
	create_world()

func _on_Timer_timeout():
	var enemy_instance = load("res://Scenes/Enemys/"+enemy_scenes[randi()%2]+".tscn").instance()
	enemy_instance.position = Vector2(500-randi() % 1000,500-randi() % 1000)
	$Enemys.add_child(enemy_instance)

func create_projectile(position=Vector2(0,0),data={},direction = Vector2(0,0)):
	var projectile_instance = projectile_scene.instance()
	projectile_instance.position = position
	projectile_instance.add_data(data)
	projectile_instance.move = direction.normalized()*data["speed"]
	yield(get_tree(),"idle_frame")
	$Projectiles.add_child(projectile_instance)
	projectile_instance.look_at(position+direction)
	projectile_instance.rotation_degrees -= 90

func create_text(text,position,color = Color(0,0,0)):
	var text_instance = load("res://Scenes/Text.tscn").instance()
	text_instance.text = str(text)
	text_instance.rect_position = position + Vector2(50 - randi() % 100,0)
	text_instance.modulate = color
	$Text.add_child(text_instance)

func create_world():
	var star = AStar2D.new()
	var point_to_astar = {}
	#var astar_to_point = {}
	var max_area = Vector2(50,50)
	
	var id = 0
	for x in range(max_area.x+10):
		for y in range(max_area.y+10):
			for n in [Vector2(x,y),Vector2(-x,-y),Vector2(x,-y),Vector2(-x,y)]:
				point_to_astar[n] = id
				#astar_to_point[id] = n
				star.add_point(id,n)
				id += 1
	for x in range(-max_area.x,max_area.x):
		for y in range(-max_area.y,max_area.y):
			star.connect_points(point_to_astar[Vector2(x,y)],point_to_astar[Vector2(x+1,y)])
			star.connect_points(point_to_astar[Vector2(x,y)],point_to_astar[Vector2(x,y+1)])
	
	var main_points = []
	for r in range(20):
		var pos
		while true:
			pos = Vector2(randi() % int((max_area.x*2))-max_area.x,randi() % int((max_area.y*2))-max_area.y)
			if $Floor.get_cellv(pos) == -1:
				break
		main_points.append(pos)
		$Floor.set_cellv(pos,0)
		var size = Vector2(randi()%4+4,randi()%4+4)
		for x in range(size.x):
			for y in range(size.y):
				$Floor.set_cellv(pos+Vector2(x,y),0)
				$Floor.set_cellv(pos+Vector2(-x,-y),0)
				$Floor.set_cellv(pos+Vector2(-x,y),0)
				$Floor.set_cellv(pos+Vector2(x,-y),0)
	
	for n in range(1,len(main_points)):
		for path in star.get_point_path(point_to_astar[main_points[n-1]],point_to_astar[main_points[n]]):
			for j in [Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1)]:
				$Floor.set_cellv(path+j,0)
				if j != Vector2(0,0):
					star.connect_points(point_to_astar[path],point_to_astar[path+j],5)
	
	for x in range(max_area.x+10):
		for y in range(max_area.y+10):
			pass
