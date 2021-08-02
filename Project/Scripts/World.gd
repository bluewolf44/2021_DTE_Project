extends Node

onready var enemy_scenes = ["Goblin","Minotaur"]
onready var projectile_scene = "res://Scenes/Projectile/"

func _ready():
	OS.set_window_maximized(true)
	randomize()
	create_world()
	create_enemys(100)

func _on_Timer_timeout():
	var enemy_instance = load("res://Scenes/Enemys/"+enemy_scenes[randi()%2]+".tscn").instance()
	var pos = Vector2(25-randi() % 50,25-randi() % 50)
	while $Nav/Title.get_cellv(pos) == -1:
		pos = Vector2(25-randi() % 50,25-randi() % 50)
		
	enemy_instance.position = $Nav/Title.map_to_world(pos)
	$Enemys.add_child(enemy_instance)

func create_enemys(number):
	var enemy_scene = []
	for n in enemy_scenes:
		enemy_scene.append(load("res://Scenes/Enemys/"+n+".tscn"))
	for e in range(number):
		var enemy_instance = enemy_scene[randi()%2].instance()
		var pos = Vector2(50-randi() % 100,50-randi() % 100)
		while $Nav/Title.get_cellv(pos) == -1:
			pos = Vector2(50-randi() % 100,50-randi() % 100)
			
		enemy_instance.position = $Nav/Title.map_to_world(pos)
		$Enemys.add_child(enemy_instance)

func create_projectile(position=Vector2(0,0),data={},direction = Vector2(0,0)):
	var projectile_instance = load(projectile_scene+data["sprite"]+".tscn").instance()
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
	text_instance.rect_position = position + Vector2(50 - randi() % 100,25 - randi() % 100)
	text_instance.modulate = color
	$Text.add_child(text_instance)

func create_world():
	var star = AStar2D.new()
	var point_to_astar = {}
	var max_area = Vector2(50,50)
	
	var id = 0
	for x in range(max_area.x+10):
		for y in range(max_area.y+10):
			for n in [Vector2(x,y),Vector2(-x,-y),Vector2(x,-y),Vector2(-x,y)]:
				point_to_astar[n] = id
				star.add_point(id,n)
				id += 1
	for x in range(-max_area.x,max_area.x):
		for y in range(-max_area.y,max_area.y):
			star.connect_points(point_to_astar[Vector2(x,y)],point_to_astar[Vector2(x+1,y)])
			star.connect_points(point_to_astar[Vector2(x,y)],point_to_astar[Vector2(x,y+1)])
	
	var not_tops = []
	var main_points = []
	for r in range(20):
		var pos = Vector2(0,0)
		while  $Floor.get_cellv(pos) != -1:
			pos = Vector2(randi() % int((max_area.x*2))-max_area.x,randi() % int((max_area.y*2))-max_area.y)
		main_points.append(pos)
		$Floor.set_cellv(pos,0)
		$Nav/Title.set_cellv(pos,0)
		var size = Vector2(randi()%4+4,randi()%4+4)
		for x in range(size.x):
			for y in range(size.y):
				for n in [Vector2(x,y),Vector2(-x,-y),Vector2(-x,y),Vector2(x,-y)]:
					$Floor.set_cellv(pos+n,0)
					$Nav/Title.set_cellv(pos+n,0)
					not_tops.append(pos+n)
				
	for n in range(1,len(main_points)):
		for path in star.get_point_path(point_to_astar[main_points[n-1]],point_to_astar[main_points[n]]):
			for j in [Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1)]:
				$Floor.set_cellv(path+j,0)
				$Nav/Title.set_cellv(path+j,0)
				not_tops.append(path+j)
				if j != Vector2(0,0):
					star.connect_points(point_to_astar[path],point_to_astar[path+j],5)
	
	for r in range(2):
		for x in range(-(max_area.x+10),max_area.x+10):
			for y in range(-(max_area.x+10),max_area.y+10):
				var pos = Vector2(x,y)
				if $Floor.get_cellv(pos) != -1:
					continue
				if ($Floor.get_cellv(pos + Vector2(0,1)) != -1 and $Floor.get_cellv(pos + Vector2(0,-1)) != -1) or ($Floor.get_cellv(pos + Vector2(1,0)) != -1 and $Floor.get_cellv(pos + Vector2(-1,0)) != -1):
					$Floor.set_cellv(pos,0)
					$Nav/Title.set_cellv(pos,0)
					not_tops.append(pos)
	
	var all_walls = []
	for x in range(-(max_area.x+10),max_area.x+10):
		for y in range(-(max_area.x+10),max_area.y+10):
			var pos = Vector2(x,y)
			if $Floor.get_cellv(pos) != -1:
				continue

			var side = {"+y":false,"-y":false,"+x":false,"-x":false}
			if $Floor.get_cellv(pos + Vector2(1,0)) != -1:
				side["+x"] = true
			if $Floor.get_cellv(pos + Vector2(-1,0)) != -1:
				side["-x"] = true
			if $Floor.get_cellv(pos + Vector2(0,1)) != -1:
				side["+y"] = true
			if $Floor.get_cellv(pos + Vector2(0,-1)) != -1:
				side["-y"] = true

			if side["-x"] and side["-y"]:
				$Wall.set_cellv(pos+Vector2(-2,-2),12)
				all_walls.append(pos)
			elif side["+x"] and side["-y"]:
				$Wall.set_cellv(pos+Vector2(-2,-2),13)
				all_walls.append(pos)
			elif side["-x"] and side["+y"]:
				$Wall.set_cellv(pos+Vector2(-2,-2),14)
				all_walls.append(pos)
			elif side["+x"] and side["+y"]:
				$Wall.set_cellv(pos+Vector2(-2,-2),11)
				all_walls.append(pos)
			elif side["-x"]:
				$Wall.set_cellv(pos+Vector2(-2,-2),8)
				all_walls.append(pos)
			elif side["-y"]:
				all_walls.append(pos)
				$Wall.set_cellv(pos+Vector2(-2,-2),7)
			elif side["+x"]:
				all_walls.append(pos)
				$Wall.set_cellv(pos+Vector2(-2,-2),3)
			elif side["+y"]:
				$Wall.set_cellv(pos+Vector2(-2,-2),4)
				all_walls.append(pos)

			elif $Floor.get_cellv(pos + Vector2(-1,-1)) != -1:
				$Wall.set_cellv(pos+Vector2(-2,-2),9)
				all_walls.append(pos)
			elif $Floor.get_cellv(pos + Vector2(1,-1)) != -1:
				$Wall.set_cellv(pos+Vector2(-2,-2),6)
				all_walls.append(pos)
			elif $Floor.get_cellv(pos + Vector2(-1,1)) != -1:
				$Wall.set_cellv(pos+Vector2(-2,-2),10)
				all_walls.append(pos)
			elif $Floor.get_cellv(pos + Vector2(1,1)) != -1:
				$Wall.set_cellv(pos+Vector2(-2,-2),5)
				all_walls.append(pos)

	for wall in all_walls:
		$Floor.set_cellv(wall,0)
		not_tops.append(wall)

	for x in range(-(max_area.x+10),max_area.x+10):
		for y in range(-(max_area.x+10),max_area.y+10):
			var pos = Vector2(x,y)
			$Top.set_cellv(pos,0)
	for pos in not_tops:
		$Top.set_cellv(pos+Vector2(-2,-2),-1)
