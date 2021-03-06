extends Node2D

var walls = {#map points
	"South":[],
	"East":[],
	"West":[],
	"North":[],
	"SouthEast":[],
	"SouthWest":[],
	"NorthWest":[],
	"NorthEast":[],}

func do_stuff():#add point into tilemap
	for wall in walls:
		match wall:
			"South":
				for n in walls[wall]:
					$TileMap.set_cellv(n,4)
			"East":
				for n in walls[wall]:
					$TileMap.set_cellv(n,5)
			"West":
				for n in walls[wall]:
					$TileMap.set_cellv(n,7)
			"North":
				for n in walls[wall]:
					$TileMap.set_cellv(n,6)
			"SouthEast":
				for n in walls[wall]:
					$TileMap.set_cellv(n,3)
			"SouthWest":
				for n in walls[wall]:
					$TileMap.set_cellv(n,2)
			"NorthWest":
				for n in walls[wall]:
					$TileMap.set_cellv(n,1)
			"NorthEast":
				for n in walls[wall]:
					$TileMap.set_cellv(n,0)
