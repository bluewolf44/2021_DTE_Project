extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
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
		var move = (player.position-position).normalized()
		travel("Run")
		$AnimationTree.set("parameters/Run/blend_position",move)
		move_and_collide(move*delta*speed)

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

func create_drop(rare = 0,stats_amount=2):
	var item = Resource.new()
	item.set_script(load("res://Resource script/Item.gd"))
	for n in range(stats_amount):
		var stat = Resource.new()
		stat.set_script(load("res://Resource script/Stats.gd"))
		stat.type = randi()%5
		stat.change = randi()%2
		stat.amount = float(randi()%10)
		
		item.stats.append(stat)
	item.name = pick_name()
	
	var drop_item_instance = load("res://Scenes/Drop_items.tscn").instance()
	drop_item_instance.data = item
	drop_item_instance.position = position
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
	][randi()%10]
