extends Node

onready var enemy_scenes = ["Goblin","Minotaur"]
onready var projectile_scene = load("res://Scenes/Projectile.tscn")

func _ready():
	randomize()

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
	text_instance.rect_position = position
	text_instance.modulate = color
	$Text.add_child(text_instance)
	
