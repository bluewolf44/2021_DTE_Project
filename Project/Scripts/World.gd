extends Node

onready var enemy_scene = load("res://Scenes/Enemys.tscn")

func _on_Timer_timeout():
	var enemy_instance = enemy_scene.instance()
	enemy_instance.position = Vector2(1000-randi() % 2000,1000-randi() % 2000)
	$Enemys.add_child(enemy_instance)
