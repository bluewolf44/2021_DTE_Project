extends KinematicBody2D

var speed = 300
var type = "player"
var attack_speed = 0.5

var other_action = false
var held_spell = {
			"effects":{"damage":10},
			"time":-1,
			"interact":["enemy","wall"],
			"sprite":{"texture":load("res://Sprites/11_fire_spritesheet.png"),"type":"fire"},
			"speed":400,
			"collionShape":{"position":Vector2(1.2,10.7),"size":Vector2(7.2,16)},
		}
		
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
		$Attack_speed.stop()
	elif not other_action:
		travel("Stand")
		$Attack_speed.stop()
	
	if Input.is_action_just_pressed("LMB") and not other_action:
		other_action = true
		held_postion = (get_global_mouse_position()-position).normalized()
		
		$AnimationTree.set("parameters/Cast/blend_position",(get_global_mouse_position()-position).normalized())
		$AnimationTree.set("parameters/Stand/blend_position",(get_global_mouse_position()-position).normalized())
		$Attack_speed.wait_time = attack_speed
		$Attack_speed.start()
		travel("Cast")

func cast_spell():
	get_parent().create_projectile(position,held_spell,held_postion)

func travel(place):
	$AnimationTree.get("parameters/playback").travel(place)

func _on_Attack_speed_timeout():
	cast_spell()
	$Attack_speed.stop()
	yield(get_tree().create_timer(0.2),"timeout")
	travel("Stand")
	yield(get_tree(),"idle_frame")
	other_action = false
