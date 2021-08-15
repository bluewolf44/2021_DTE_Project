extends Node2D

func go_to(data):
	var world = load("res://Scenes/World.tscn").instance()
	world.enemy_scenes = []
	for m in data.monsters:
		world.enemy_scenes.append(m.input)
	world.amount_monster = data.amount_monster
	world.max_size = data.max_size
	world.tile = data.tile
	world.min_level = data.min_level
	world.max_level = data.max_level
	world.rooms = data.rooms
	get_tree().get_root().add_child(world)
	queue_free()
