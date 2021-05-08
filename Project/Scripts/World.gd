extends Node

onready var enemy_scene = load("res://Scenes/Enemys.tscn")
onready var projectile_scene = load("res://Scenes/Projectile.tscn")

func _on_Timer_timeout():
	var enemy_instance = enemy_scene.instance()
	enemy_instance.position = Vector2(1000-randi() % 2000,1000-randi() % 2000)
	$Enemys.add_child(enemy_instance)

func create_projectile(position=Vector2(0,0),data={},direction = Vector2(0,0)):
	var projectile_instance = projectile_scene.instance()
	projectile_instance.position = position
	projectile_instance.look_at(position+direction)
	projectile_instance.rotation_degrees -= 90
	projectile_instance.add_data(data)
	if data.has("speed"):
		projectile_instance.move = direction.normalized()*data["speed"]
	$Projectiles.add_child(projectile_instance)
