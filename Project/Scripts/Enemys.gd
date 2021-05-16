extends KinematicBody2D
	
onready var player = get_parent().get_parent().get_node("Player")

var speed = 150
var type = "Enemy"
var health = 50

func _process(delta):
	if position.distance_to(player.position) < 600:
		move_and_collide((player.position-position).normalized()*delta*speed)

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
