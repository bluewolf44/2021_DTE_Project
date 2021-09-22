tool
extends Sprite

export var west = true setget change_sprite
var type = "exit"

func _process(delta):
	if not Engine.editor_hint:
		if Input.is_action_just_pressed("Q"): #when Q got to map with in area
			if $Area2D.overlaps_area(get_node("../../Player/Area2D")):
				get_tree().change_scene("res://Scenes/Map.tscn")
			

func change_sprite(change):#bool for which side the sprtite and area is on
	west = change
	if change:
		region_rect = Rect2(Vector2(192,880),Vector2(96,112))
		$Area2D/CollisionShape2D.position = Vector2(48,48)
	else:
		region_rect = Rect2(Vector2(288,880),Vector2(96,112))
		$Area2D/CollisionShape2D.position = Vector2(-48,48)

func _ready():
	change_sprite(west)
