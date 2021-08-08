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
					$TileMap.set_cellv(n,0)
			"East":
				pass
			"West":
				pass
			"North":
				pass
