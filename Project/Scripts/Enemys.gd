extends KinematicBody2D
	
onready var player = get_parent().get_parent().get_node("Player")

var speed = 200

func _process(delta):
	position = position.move_toward(player.position,delta*speed)
