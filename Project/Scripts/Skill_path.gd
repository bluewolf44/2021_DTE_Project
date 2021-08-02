tool
extends Node2D

onready var Points = get_node("../../Points")
export var id1 = -1 setget set_name1
export var id2 = -1 setget set_name2
var point1
var point2

func set_name1(change):
	id1 = change
	name = str(id1)+ " " + str(id2)
	update()

func set_name2(change):
	id2 = change
	name = str(id1)+ " " + str(id2)
	update()

func update():
	if id1 >= 0 and id2 >= 0:
		point1 = get_node("../../Points/"+str(id1))
		point2 = get_node("../../Points/"+str(id2))
		
		if point1 and point2:
			position = point1.position
			#position = position.move_toward(point2.position,5)
			scale.y = (point2.position.distance_to(point1.position)-10)/32
			look_at(point2.position)
			rotation_degrees -= 90
