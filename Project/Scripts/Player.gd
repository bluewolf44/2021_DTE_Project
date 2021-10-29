extends KinematicBody2D

var speed = 300
var type = "Player"
var other_action = false

var held_action = 0

var held_postion
var move_towards
var has_move = false
var regen = true

var move_inv = false

func _ready():#add stats
	update_xp()
	$CanvasLayer/Health_bar/Max_Health.text = str(PlayerData.health)
	$CanvasLayer/Health_bar/Health.text = str(PlayerData.health)
	$CanvasLayer/Health_bar/ProgressBar.max_value = PlayerData.health
	$CanvasLayer/Health_bar/ProgressBar.value = PlayerData.health
	
	$CanvasLayer/Mana_bar/Mana.text = str(PlayerData.mana)
	$CanvasLayer/Mana_bar/Max_Mana.text = str(PlayerData.mana)
	$CanvasLayer/Mana_bar/ProgressBar.max_value = PlayerData.mana
	$CanvasLayer/Mana_bar/ProgressBar.value = PlayerData.mana
	
	for n in range(1,11):#added texture to hot buttons
		if len(PlayerData.action_hold) > n:
			$CanvasLayer/Hot_bar.get_node(str(n)+"/Sprite").texture = PlayerData.action_hold[n].icon
		else:
			$CanvasLayer/Hot_bar.get_node(str(n)+"/Sprite").texture = null
	PlayerData.update_stats()

func _process(delta):
	var move = Vector2( #test when key is pressed
		Input.get_action_strength("Move_Right")-Input.get_action_strength("Move_Left"),
		Input.get_action_strength("Move_Down")-Input.get_action_strength("Move_Up")
		)
	move_and_slide(move.normalized()*speed) #move player
	$CanvasLayer/Mini/ViewportContainer/Viewport/Camera2D.position = position/5 #move the minimap 
	if move: #stop attack if move
		other_action = false
		travel("Run")
		$AnimationTree.set("parameters/Stand/blend_position",move)
		$AnimationTree.set("parameters/Run/blend_position",move)
		$Attack_speed.stop()
	
	elif not other_action: #stop moving
		travel("Stand")
		$Attack_speed.stop()
	
	if Input.is_action_just_pressed("E"): #open inv
		open_inv()
	
	if move_inv: #when move
		$CanvasLayer/Move.position = get_viewport().get_mouse_position()
	
	if not other_action and PlayerData.place != "town":#start attack
		if Input.is_action_just_pressed("LMB") and not (get_viewport().get_mouse_position().x >= 1175 and $CanvasLayer/Inventory.visible):
			held_action = 0
			start_attack()
		elif Input.is_action_just_pressed("0") and PlayerData.action_hold.size() == 11:
			held_action = 10
			start_attack()
		elif Input.is_action_just_pressed("1") and PlayerData.action_hold.size() >= 2:
			held_action = 1
			start_attack()
		elif Input.is_action_just_pressed("2") and PlayerData.action_hold.size() >= 3:
			held_action = 2
			start_attack()
		elif Input.is_action_just_pressed("3") and PlayerData.action_hold.size() >= 4:
			held_action = 3
			start_attack()
		elif Input.is_action_just_pressed("4") and PlayerData.action_hold.size() >= 5:
			held_action = 4
			start_attack()
		elif Input.is_action_just_pressed("5") and PlayerData.action_hold.size() >= 6:
			held_action = 5
			start_attack()
		elif Input.is_action_just_pressed("6") and PlayerData.action_hold.size() >= 7:
			held_action = 6
			start_attack()
		elif Input.is_action_just_pressed("7") and PlayerData.action_hold.size() >= 8:
			held_action = 7
			start_attack()
		elif Input.is_action_just_pressed("8") and PlayerData.action_hold.size() >= 9:
			held_action = 8
			start_attack()
		elif Input.is_action_just_pressed("9") and PlayerData.action_hold.size() >= 10:
			held_action = 9
			start_attack()
		
	if PlayerData.mana > PlayerData.mana_current:#mana regen
		PlayerData.mana_current = move_toward(PlayerData.mana_current,PlayerData.mana,PlayerData.mana_regen*delta)
		$CanvasLayer/Mana_bar/Mana.text = str(round(PlayerData.mana_current))
		$CanvasLayer/Mana_bar/ProgressBar.value = round(PlayerData.mana_current)
	if PlayerData.health > PlayerData.current_health: #health regen
		if regen:
			PlayerData.current_health = move_toward(PlayerData.current_health,PlayerData.health,PlayerData.health_reg*delta*5)
		else:
			PlayerData.current_health = move_toward(PlayerData.current_health,PlayerData.health,PlayerData.health_reg*delta)
		$CanvasLayer/Health_bar/Health.text = str(round(PlayerData.current_health))
		$CanvasLayer/Health_bar/ProgressBar.value = round(PlayerData.current_health)
		
func cast_spell():#tells world to create project with stats
	if PlayerData.action_hold[held_action]["where"].type == 0:
		get_parent().create_projectile(position+held_postion*PlayerData.action_hold[held_action]["where"].amount,PlayerData.action_hold[held_action],held_postion)
	elif PlayerData.action_hold[held_action]["where"][0] == 1:
		get_parent().create_projectile(position,PlayerData.action_hold[held_action],held_postion)

func travel(place):#set up animationtree
	$AnimationTree.get("parameters/playback").travel(place)

func _on_Attack_speed_timeout():#reset attack
	cast_spell()
	$Attack_speed.stop()
	yield(get_tree().create_timer(0.2),"timeout")
	travel("Stand")
	yield(get_tree(),"idle_frame")
	other_action = false

func hit(damage):#when player gets hit
	PlayerData.current_health -= damage
	$CanvasLayer/Health_bar/Health.text = str(PlayerData.current_health)
	$CanvasLayer/Health_bar/ProgressBar.value = PlayerData.current_health
	regen = false
	$Regen.start()#set timer for regegn
	if PlayerData.current_health <= 0:
		died()

func start_attack(): #when attack
	if PlayerData.mana_current < PlayerData.action_hold[held_action].cost:
		return
	PlayerData.mana_current -= PlayerData.action_hold[held_action].cost
	$CanvasLayer/Mana_bar/Mana.text = str(PlayerData.mana_current)
	$CanvasLayer/Mana_bar/ProgressBar.value = PlayerData.mana_current
	other_action = true
	held_postion = (get_global_mouse_position()-position).normalized()
	
	$AnimationTree.set("parameters/Cast/blend_position",(get_global_mouse_position()-position).normalized())#make player look toward the mouse
	$AnimationTree.set("parameters/Stand/blend_position",(get_global_mouse_position()-position).normalized())
	$Attack_speed.wait_time = PlayerData.action_hold[held_action].cast_time
	$Attack_speed.start()
	travel("Cast")

func died():
	get_tree().change_scene("res://Scenes/Map.tscn")

func interact(effects,projective):#when projective interact with players
	for e in effects:
		match e.type:
			"damage":
				if is_instance_valid(projective.sender):
					hit(e.input+projective.sender.attack)
				else:
					hit(e.input)

func open_inv():
	$CanvasLayer/Inventory.visible = !$CanvasLayer/Inventory.visible
	if $CanvasLayer/Inventory.visible:
		update_inv()

func update_inv(): #rest texture for invitory
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

func move_item(data):#move data to move
	$CanvasLayer/Inventory/Button.rect_size = Vector2(1058,955)
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
	
func show_info(slot,data):#open the info box for an item
	var info = $CanvasLayer/Inventory/Info
	info.visible = true
	info.rect_position = slot.rect_position + slot.get_parent().rect_position + Vector2(0,64)
	if $CanvasLayer/Inventory.rect_position.x + info.rect_position.x + info.get_node("ColorRect").rect_size.x >= get_viewport_rect().size.x/0.75:
		info.rect_position.x -= 32*(int(($CanvasLayer/Inventory.rect_position.x + info.rect_position.x + info.get_node("ColorRect").rect_size.x - get_viewport_rect().size.x)/32) + 1)
	if data.sprite:
		info.get_node("Sprite").texture = data.sprite
	if data.name:
		info.get_node("Name").text = data.name
	info.get_node("Type").text = ["Chest","Ring","Legs","Head","Weapon"][data.type]
	for n in info.get_node("Stats").get_children():
		n.queue_free()
	
	for stat in data.stats:
		var l = Label.new()
		l.text = ["Damage","Heath","Defence","Speed","Crit","Crit Dam","Mana","Mana regen"][stat.type] + [" + "," +% "][stat.change] + str(stat.amount)
		info.get_node("Stats").add_child(l)

func updata_stats():#restes the bars
	$CanvasLayer/Health_bar/Max_Health.text = str(PlayerData.health)
	$CanvasLayer/Mana_bar/Max_Mana.text = str(PlayerData.mana)
	$CanvasLayer/Mana_bar/ProgressBar.max_value = PlayerData.mana
	$CanvasLayer/Health_bar/ProgressBar.max_value = PlayerData.health
	speed = PlayerData.speed

func _on_Button_button_up(): #drop an item into the world
	if $CanvasLayer/Move.data:
		var drop_item_instance = load("res://Scenes/Drop_items.tscn").instance()
		drop_item_instance.data = $CanvasLayer/Move.data
		drop_item_instance.position = position
		drop_item_instance.get_node("Icon").modulate = $CanvasLayer/Move.data.color
		get_parent().get_node("Drop_items").add_child(drop_item_instance)
		PlayerData.remove_item($CanvasLayer/Move.data)
		reset_move()
		
func update_xp(): #the hot_bar xp
	$CanvasLayer/Hot_bar/XP.max_value = PlayerData.xp_to_next
	$CanvasLayer/Hot_bar/XP.value = PlayerData.current_xp
	$CanvasLayer/Hot_bar/Lvl.text = str(PlayerData.lvl)

func _on_Inventory_button_up():
	open_inv()

func _on_Skill_tree_button_up():
	open_skill()

func open_skill(): #open skill tree and paused the game behind
	$CanvasLayer/Skill_tree.visible = !$CanvasLayer/Skill_tree.visible
	if $CanvasLayer/Skill_tree.visible:
		$CanvasLayer/Skill_tree.base_place = Vector2(960,500)
		$CanvasLayer/Skill_tree.position = Vector2(960,500)
		$CanvasLayer/Skill_tree/CanvasModulate/Points.visible = true
		$CanvasLayer/Skill_tree/CanvasModulate/Label.visible = true
		$CanvasLayer/Skill_tree/CanvasModulate/Restart.visible = true
		get_tree().paused = true
		$Camera2D.current = false
	else:
		$CanvasLayer/Skill_tree.done_skill()
		$CanvasLayer/Skill_tree/CanvasModulate/Restart.visible = false
		$CanvasLayer/Skill_tree/CanvasModulate/Points.visible = false
		$CanvasLayer/Skill_tree/CanvasModulate/Label.visible = false
		$Camera2D.current = true
		get_tree().paused = false


func _on_Regen_timeout():
	regen = true
