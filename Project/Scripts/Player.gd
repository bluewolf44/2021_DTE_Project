extends KinematicBody2D

var speed = 300
var type = "player"

var other_action = false
var held_spell
var held_postion

var move_towards
var has_move = false

func _process(delta):
	var move = Vector2(
		Input.get_action_strength("Move_Right")-Input.get_action_strength("Move_Left"),
		Input.get_action_strength("Move_Down")-Input.get_action_strength("Move_Up")
		)
	move_and_slide(move.normalized()*speed)
	if move:
		other_action = false
		travel("Run")
		$AnimationTree.set("parameters/Stand/blend_position",move)
		$AnimationTree.set("parameters/Run/blend_position",move)
	elif not other_action:
		travel("Stand")
	
	if Input.is_action_just_pressed("LMB"):
		other_action = true
		
		held_spell = {
			"effects":{"damage":10},
			"time":-1,
			"interact":["enemy","wall"],
			"texture":load("res://Sprites/11_fire_spritesheet.png"),
			"speed":400
		}
		
		held_postion = (get_global_mouse_position()-position).normalized()
		$AnimationTree.set("parameters/Cast/blend_position",(get_global_mouse_position()-position).normalized())
		travel("Cast")

func cast_spell():
	get_parent().create_projectile(position,held_spell,held_postion)
	yield(get_tree().create_timer(0.2), "timeout")
	other_action = false

func travel(place):
	$AnimationTree.get("parameters/playback").travel(place)
