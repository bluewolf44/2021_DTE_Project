extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")

var speed = 150
var type = "Enemy"
var health = 50
var action = false

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
	$Attack.look_at(player.position)
	$Attack.rotation_degrees -= 90
	action = true
	$AnimationTree.set("parameters/Attack/blend_position",(player.position-position).normalized())
	travel("Attack")

func attack():
	if $Attack.overlaps_area(player.get_node("Area2D")):
		player.hit(5)

func attack_reset():
	action = false

func travel(place):
	$AnimationTree.get("parameters/playback").travel(place)
