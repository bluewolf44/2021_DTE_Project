extends KinematicBody2D

var speed = 300
var type = "Player"
var attack_speed = 0.25
var other_action = false

var held_action = 0
var action_hold = [load("res://Resoures/Fire_ball2.tres"),load("res://Resoures/Slash.tres")]

var held_postion
var move_towards
var has_move = false

func _ready():
	$CanvasLayer/Health_bar/Max_Health.text = str(get_node("/root/PlayerData").health)
	$CanvasLayer/Health_bar/Health.text = str(get_node("/root/PlayerData").health)
	$CanvasLayer/Health_bar/ProgressBar.max_value = get_node("/root/PlayerData").health

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
	
	elif Input.is_action_just_pressed("Q"):
		held_action += 1
		if held_action >= 2:
			held_action = 0

func cast_spell():
	if action_hold[held_action]["where"].type == 0:
		get_parent().create_projectile(position+held_postion*action_hold[held_action]["where"].amount,action_hold[held_action],held_postion)
	elif action_hold[held_action]["where"][0] == 1:
		get_parent().create_projectile(position,action_hold[held_action],held_postion)

func travel(place):
	$AnimationTree.get("parameters/playback").travel(place)

func _on_Attack_speed_timeout():
	cast_spell()
	$Attack_speed.stop()
	yield(get_tree().create_timer(0.2),"timeout")
	travel("Stand")
	yield(get_tree(),"idle_frame")
	other_action = false

func hit(damage):
	get_node("/root/PlayerData").health -= damage
	$CanvasLayer/Health_bar/Health.text = str(get_node("/root/PlayerData").health)
	$CanvasLayer/Health_bar/ProgressBar.value += damage
	print(get_node("/root/PlayerData").health," ",-damage)
	if get_node("/root/PlayerData").health <= 0:
		died()

func died():
	queue_free()

func interact(effects):
	for e in effects:
		match e.type:
			"damage":
				hit(e.input)
