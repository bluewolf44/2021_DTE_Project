extends KinematicBody2D

var speed = 300
var type = "Player"
var other_action = false

var held_action = 0
var action_hold = [load("res://Resoures/Fire_ball2.tres"),load("res://Resoures/Slash.tres"),load("res://Resoures/Blue_Flame.tres")]

var held_postion
var move_towards
var has_move = false

var move_inv = false

func _ready():
	update_xp()
	$CanvasLayer/Health_bar/Max_Health.text = str(PlayerData.health)
	$CanvasLayer/Health_bar/Health.text = str(PlayerData.health)
	$CanvasLayer/Health_bar/ProgressBar.max_value = PlayerData.health
	for n in range(1,len(action_hold)):
		$CanvasLayer/Hot_bar.get_node(str(n)+"/Sprite").texture = action_hold[n].icon
	

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
	
	if Input.is_action_just_pressed("E"):
		open_inv()
	
	if move_inv:
		$CanvasLayer/Move.position = get_viewport().get_mouse_position()
	
	if not other_action:
		if Input.is_action_just_pressed("LMB"):
			held_action = 0
			start_attack()	
		elif Input.is_action_just_pressed("0") and action_hold.size() == 11:
			held_action = 10
			start_attack()	
		elif Input.is_action_just_pressed("1") and action_hold.size() >= 2:
			held_action = 1
			start_attack()	
		elif Input.is_action_just_pressed("2") and action_hold.size() >= 3:
			held_action = 2
			start_attack()	
		elif Input.is_action_just_pressed("3") and action_hold.size() >= 4:
			held_action = 3
			start_attack()	
		elif Input.is_action_just_pressed("4") and action_hold.size() >= 5:
			held_action = 4
			start_attack()	
		elif Input.is_action_just_pressed("5") and action_hold.size() >= 6:
			held_action = 5
			start_attack()	
		elif Input.is_action_just_pressed("6") and action_hold.size() >= 7:
			held_action = 6
			start_attack()	
		elif Input.is_action_just_pressed("7") and action_hold.size() >= 8:
			held_action = 7
			start_attack()	
		elif Input.is_action_just_pressed("8") and action_hold.size() >= 9:
			held_action = 8
			start_attack()	
		elif Input.is_action_just_pressed("9") and action_hold.size() >= 10:
			held_action = 9
			start_attack()	
	
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
	PlayerData.current_health -= damage
	$CanvasLayer/Health_bar/Health.text = str(PlayerData.current_health)
	$CanvasLayer/Health_bar/ProgressBar.value += damage
	#print(get_node("/root/PlayerData").health," ",-damage)
	if PlayerData.current_health <= 0:
		died()

func start_attack():
	other_action = true
	held_postion = (get_global_mouse_position()-position).normalized()
	
	$AnimationTree.set("parameters/Cast/blend_position",(get_global_mouse_position()-position).normalized())
	$AnimationTree.set("parameters/Stand/blend_position",(get_global_mouse_position()-position).normalized())
	$Attack_speed.wait_time = action_hold[held_action].cast_time
	$Attack_speed.start()
	travel("Cast")

func died():
	queue_free()

func interact(effects,projective):
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
			slot.get_node("icon").modulate = Color(0,0,0)
			slot.data = null
		
	for item_num in range(60):
		var item = PlayerData.inventory[item_num]
		if item:
			var slot = get_node("CanvasLayer/Inventory/Slots/"+str(item_num))
			if item.sprite:
				slot.get_node("icon").texture = item.sprite
			else:
				slot.get_node("icon").modulate = item.color
			slot.data = item

func move_item(data):
	$CanvasLayer/Inventory/Button.rect_size = Vector2(614,511)
	$CanvasLayer/Inventory/Info.visible = false
	$CanvasLayer/Move.data = data
	$CanvasLayer/Move.modulate = data.color
	$CanvasLayer/Move.visible = true
	if data.sprite:
		$CanvasLayer/Move.texture = data.sprite
	move_inv = true
	
func reset_move():
	$CanvasLayer/Inventory/Button.rect_size = Vector2(0,0)
	$CanvasLayer/Move.data = null
	$CanvasLayer/Move.visible = false
	move_inv = false
	
func show_info(slot,data):
	var info = $CanvasLayer/Inventory/Info
	info.visible = true
	info.rect_position = slot.rect_position + slot.get_parent().rect_position + Vector2(0,32)
	if $CanvasLayer/Inventory.rect_position.x + info.rect_position.x + info.get_node("ColorRect").rect_size.x >= get_viewport_rect().size.x:
		info.rect_position.x -= 36*(int(($CanvasLayer/Inventory.rect_position.x + info.rect_position.x + info.get_node("ColorRect").rect_size.x - get_viewport_rect().size.x)/36) + 1)
	if data.sprite:
		info.get_node("Sprite").texture = data.sprite
	if data.name:
		info.get_node("Name").text = data.name
	info.get_node("Type").text = ["Chest","Ring","Legs","Head","Weapon"][data.type]
	for n in info.get_node("Stats").get_children():
		n.queue_free()
	
	for stat in data.stats:
		var l = Label.new()
		l.text = ["Damage","Heath","Defence","Speed","Crit","Crit Dam"][stat.type] + [" + "," +% "][stat.change] + str(stat.amount)
		info.get_node("Stats").add_child(l)

func updata_stats():
	$CanvasLayer/Health_bar/Max_Health.text = str(PlayerData.health)
	$CanvasLayer/Health_bar/ProgressBar.max_value = PlayerData.health
	speed = PlayerData.speed

func _on_Button_button_up():
	if $CanvasLayer/Move.data:
		var drop_item_instance = load("res://Scenes/Drop_items.tscn").instance()
		drop_item_instance.data = $CanvasLayer/Move.data
		drop_item_instance.position = position
		drop_item_instance.get_node("Icon").modulate = $CanvasLayer/Move.data.color
		get_parent().get_node("Drop_items").add_child(drop_item_instance)
		PlayerData.remove_item($CanvasLayer/Move.data)
		reset_move()
		
func update_xp():
	$CanvasLayer/Hot_bar/XP.max_value = PlayerData.xp_to_next
	$CanvasLayer/Hot_bar/XP.value = PlayerData.current_xp
	$CanvasLayer/Hot_bar/Lvl.text = str(PlayerData.lvl)
