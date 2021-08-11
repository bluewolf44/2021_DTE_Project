extends Node2D

var walls = {
	"South":[],
	"East":[],
	"West":[],
	"North":[],
	"SouthEast":[],
	"SouthWest":[],
	"NorthWest":[],
	"NorthEast":[],}

func do_stuff():
	for wall in walls:
		match wall:
			"South":
				for n in walls[wall]:
					$TileMap.set_cellv(n,2)
			"East":
				for n in walls[wall]:
					$TileMap.set_cellv(n,3)
			"West":
				for n in walls[wall]:
					$TileMap.set_cellv(n,0)
			"North":
				for n in walls[wall]:
					$TileMap.set_cellv(n,1)
			"SouthEast":
				for n in walls[wall]:
					$TileMap.set_cellv(n,7)
			"SouthWest":
				for n in walls[wall]:
					$TileMap.set_cellv(n,6)
			"NorthWest":
				for n in walls[wall]:
					$TileMap.set_cellv(n,5)
			"NorthEast":
				for n in walls[wall]:
					$TileMap.set_cellv(n,4)
