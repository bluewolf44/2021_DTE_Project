extends KinematicBody2D
	
onready var player = get_parent().get_parent().get_node("Player")

var speed = 150
var type = "Enemy"

func _process(delta):
	if position.distance_to(player.position) < 600:
		move_and_collide((player.position-position).normalized()*delta*speed)

func interact(effects):
	print(effects)
	queue_free()
