extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var nav = get_parent().get_parent().get_node("Nav")
var type = "Enemy"

export(Resource) var monster_data
var held_action
var can_get_hit = true

var speed
var health
var attack = 1
var action = false
var level = 1
var can_see = false
var on_mimi

func _ready():#add stats for data
	attack = level
	visible = false
	$Timer.wait_time = 0.5
	held_action = monster_data["attack"]
	speed = monster_data.speed
	health = monster_data.health*level
	
	var s = Sprite.new()#add to mini map
	s.texture = load("res://icon.png")
	s.modulate = Color(1,0,0)
	s.visible = false
	s.scale = Vector2(0.25,0.25)
	s.position = position/5
	get_node("../../Player/CanvasLayer/Mini/ViewportContainer/Viewport/Enemys").add_child(s)
	on_mimi = s

func _process(delta):#check if player with in visabliy or argo range or attack distance
	if position.distance_to(player.position) <= monster_data.distance and not action:
		start_attack()
	elif can_see and not action: #moves towards player with path finding
		var move = (nav.get_simple_path(position,player.position)[1]-position).normalized()
		move_and_collide(move*speed*delta)
		on_mimi.position = position/5
		travel("Run")
		$AnimationTree.set("parameters/Run/blend_position",(player.position-position).normalized())
	if position.distance_to(player.position) <= 300:#if in range of player
		can_see = true
		visible = true
		on_mimi.visible = true
	elif position.distance_to(player.position) <= 500: #show player but dosn't attack player
		visible = true
		on_mimi.visible = true
	elif position.distance_to(player.position) <= 800:#hides enemy when to far away
		can_see = false
		visible = false
		on_mimi.visible = false

func interact(effects,projective):#when project hit enemy
	for e in effects:
		match e.type:
			"damage":#deal damgae
				if can_get_hit:
					var total = (e.input + PlayerData.attack)*int(int(PlayerData.crit/100+1)*(PlayerData.dam_crit/100+1))
					if randi() % 100 <= int(PlayerData.crit) % 100:
						total += round((PlayerData.dam_crit/100+1)*(e.input + PlayerData.attack))
					
					health -= total
					get_parent().get_parent().create_text(str(total),position,Color("eb0c0c"))
					if health <= 0:
						died()
					can_get_hit = false
					$Timer.start()
			"after_projectile":#create a second projectile
				if not projective.has_after:
					get_node("/root/World").create_projectile(projective.position,e.input)
					projective.has_after = true
		can_see = true

func died():#drop item and goal
	yield(get_tree(),"idle_frame")
	PlayerData.create_drop(position)
	PlayerData.create_gold(position,level)
	var xp = round(monster_data.xp*(rand_range(0.7,1.3)))*level
	PlayerData.gain_xp(xp)
	get_parent().get_parent().create_text(str(xp) + " Xp",position,Color("1df516"))
	on_mimi.queue_free()
	queue_free()

func start_attack(): #attacking player
	action = true
	$AnimationTree.set("parameters/Attack/blend_position",(player.position-position).normalized())
	travel("Attack")

func attack():#create projectile from world
	get_parent().get_parent().create_projectile(position+held_action.distance*(player.position-position).normalized(),held_action,(player.position-position).normalized(),self)

func attack_reset():
	action = false

func travel(place):
	$AnimationTree.get("parameters/playback").travel(place)

func _on_Timer_timeout():
	can_get_hit = true
