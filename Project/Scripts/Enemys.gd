extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var nav = get_parent().get_parent().get_node("Nav")
var type = "Enemy"

export(Resource) var monster_data
var held_action
var can_get_hit = true

var speed
var health
var action = false

func _ready():
	held_action = monster_data["attack"]
	speed = monster_data.speed
	health = monster_data.health

func _process(delta):
	if position.distance_to(player.position) <= monster_data.distance and not action:
		start_attack()
	elif position.distance_to(player.position) < 600 and not action:
		var move = (nav.get_simple_path(position,player.position)[1]-position).normalized()
		move_and_collide(move*speed*delta)
		travel("Run")
		$AnimationTree.set("parameters/Run/blend_position",(player.position-position).normalized())

func interact(effects):
	if can_get_hit:
		for e in effects:
			match e.type:
				"damage":
					health -= e.input
					if health <= 0:
						died()
				"after_projectile":
					get_node("/root/World").create_projectile(position,e.input)
		can_get_hit = false
		$Timer.start()

func died():
	yield(get_tree(),"idle_frame")
	create_drop()
	queue_free()

func start_attack():
	action = true
	$AnimationTree.set("parameters/Attack/blend_position",(player.position-position).normalized())
	travel("Attack")

func attack():
	get_parent().get_parent().create_projectile(position+held_action.distance*(player.position-position).normalized(),held_action,(player.position-position).normalized())

func attack_reset():
	action = false

func travel(place):
	$AnimationTree.get("parameters/playback").travel(place)

func _on_Timer_timeout():
	can_get_hit = true

func create_drop():
	var rare = PlayerData.run_random({"max":1000,range(300,1000):0,range(150,300):1,range(80,150):2,range(30,80):3,range(5,30):4,range(5):5})
	if rare == 0:
		return
	
	var item = Resource.new()
	item.set_script(preload("res://Resource script/Item.gd"))
	item.stats = []
	for n in range(rare + 1):
		var stat = Resource.new()
		stat.set_script(preload("res://Resource script/Stats.gd"))
		stat.type = randi()%5
		stat.change = randi()%2
		stat.amount = (float(randi()%10)+1)*rare
		item.stats.append(stat)
	item.name = pick_name()
	item.color = ["",Color(1,1,1),Color(0,1,0),Color(0,0,1),Color("C947F5"),Color("FF6600")][rare]
	item.type = randi()%5
	
	var drop_item_instance = load("res://Scenes/Drop_items.tscn").instance()
	drop_item_instance.data = item
	drop_item_instance.position = position
	drop_item_instance.get_node("Icon").modulate = item.color
	get_parent().get_parent().get_node("Drop_items").add_child(drop_item_instance)

func pick_name():
	return [
		"Soulsiphon",
		"Blightspore",
		"Soulkeeper",
		"Sunlight",
		"Holy Aspect",
		"Champion Ornament",
		"Thundersoul Stone",
		"Scar, Trinket of the Caged Mind",
		"Mercy, Hope of Silence",
		"Nirvana, Aspect of Desecration",
		"Randy Ortain",
		"Peenexcalibur",
		"Mini sucktion cup man",
	][randi()%13]
