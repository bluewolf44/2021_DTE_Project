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

var move_inv = false

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
	
	if Input.is_action_just_pressed("E"):
		open_inv()
	
	if move_inv:
		$CanvasLayer/Move.position = get_viewport().get_mouse_position()

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

func open_inv():
	$CanvasLayer/Inventory.visible = !$CanvasLayer/Inventory.visible
	if $CanvasLayer/Inventory.visible:
		update_inv()

func update_inv():
	for slot in $CanvasLayer/Inventory/Slots.get_children():
			slot.get_node("icon").texture = load("res://icon.png")
			slot.get_node("icon").modulate = Color(1,1,1)
			slot.data = null
		
	for item_num in range(60):
		var item = PlayerData.inventory[item_num]
		if item:
			var slot = get_node("CanvasLayer/Inventory/Slots/"+str(item_num))
			if item.sprite:
				slot.get_node("icon").texture = item.sprite
			else:
				slot.get_node("icon").modulate = Color(0,1,0)
			slot.data = item

func move_item(data):
	$CanvasLayer/Move.data = data
	$CanvasLayer/Move.modulate = Color(0,1,0)
	$CanvasLayer/Move.visible = true
	if data.sprite:
		$CanvasLayer/Move.texture = data.sprite
	move_inv = true
	
func reset_move():
	$CanvasLayer/Move.data = null
	$CanvasLayer/Move.visible = false
	$CanvasLayer/Move.texture = load("res://icon.png")
	$CanvasLayer/Move.modulate = Color(1,1,1)
	move_inv = false
	
func show_info(slot,data):
	var info = $CanvasLayer/Inventory/Info
	info.visible = true
	info.rect_position = slot.rect_position + slot.get_parent().rect_position + Vector2(0,32)
	if data.sprite:
		info.get_node("Sprite").texture = data.sprite
	if data.name:
		info.get_node("Name").text = data.name
	info.get_node("Des").text = data.description
