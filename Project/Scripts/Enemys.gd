extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
var type = "Enemy"

export(Resource) var monster_data
var held_action

var speed
var health
var action = false

func _ready():
	held_action = monster_data["attack"]
	speed = monster_data.speed
	health = monster_data.health

func _process(delta):
	if position.distance_to(player.position) <= 80 and not action:
		start_attack()
	elif position.distance_to(player.position) < 600 and not action:
		var move = (player.position-position).normalized()
		travel("Run")
		$AnimationTree.set("parameters/Run/blend_position",move)
		move_and_collide(move*delta*speed)

func interact(effects):
	for e in effects:
		match e.type:
			"damage":
				health -= e.input
				if health <= 0:
					died()
			"after_projectile":
				get_node("/root/World").create_projectile(position,e.input)

func died():
	yield(get_tree(),"idle_frame")
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
