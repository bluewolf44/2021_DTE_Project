extends Node

var health = 100 #current stats
var current_health = 100
var health_reg = 1
var attack = 5
var defence = 4
var crit = 5
var dam_crit = 5
var speed = 200
var mana = 100
var mana_current = 100
var mana_regen = 5

var base_health = 100 #base stats with inprove with lvl
var base_attack = 5
var base_health_reg = 1
var base_defence = 4
var base_crit = 5
var base_dam_crit = 5
var base_speed = 200
var base_mana = 100
var base_mana_regen = 3

var add_health = 0 #add to base
var add_health_reg = 0
var add_attack = 0
var add_defence = 0
var add_crit = 0
var add_dam_crit = 0
var add_speed = 0
var add_mana = 0
var add_mana_regen = 0

var per_health = 0 #incrace by perstange
var per_health_reg = 0
var per_attack = 0
var per_defence = 0
var per_crit = 0
var per_speed = 0
var per_dam_crit = 0
var per_mana = 0
var per_mana_regen = 0

var skill_stats = []
var inventory = []
var equited = {}
var gold = 0
var place = ""
var map_been = []


var lvl = 1
var current_xp = 0
var xp_to_next = 30

var action_hold = [load("res://Resoures/Fire_ball2.tres")]

func _ready(): #set maximized window
	OS.set_window_maximized(true)
	randomize()
	for n in range(60):
		inventory.append(null)

func add_item(data): #add item to invitory
	for n in range(60):
		if not inventory[n]:
			inventory[n] = data
			break

func remove_item(data):
	inventory[inventory.find(data)] = null

func run_random(data,change):# data = {change:answer,120:1,40:2,10:3,4:4,1:5}
	var total = 0 #pick a randium output compart to when u put in
	var hold = []
	for d in data:
		total += d
		hold.append({"rare":total,"res":data[d]})
		
	var rand = randi() % total
	for h in hold:
		if rand <= h["rare"]:
			return h["res"]

func update_stats():
	for n in ["add","per"]:#resets add and per stats
		for i in ["attack","health","defence","speed","crit","dam_crit","mana","mana_regen","health_reg"]:
			self[n + "_"+ i] = 0
	var total = skill_stats#get stats from the skill tree and equitment
	for e in equited:
		if equited[e]:
			for stat in equited[e].stats:
				total.append(stat)
	
	for stat in total:#sets stats from skill tree and equitment
		self[["add","per"][stat.change]+"_"+["attack","health","defence","speed","crit","dam_crit","mana","mana_regen","health_reg"][stat.type]] += stat.amount
	#sets the stats
	for i in ["attack","health","defence","speed","crit","dam_crit","mana","mana_regen","health_reg"]:
		self[i] = round((self["per_" + i]/100+1)*self["base_" + i] + self["add_" + i])
	if get_node("/root/World/Player"):
		get_node("/root/World/Player").updata_stats()

func gain_xp(number): #gain xp
	current_xp += number
	while current_xp >= xp_to_next: #lvl up
		current_xp -= xp_to_next
		xp_to_next = 5*lvl*lvl+95
		lvl += 1
		base_attack += 2
		base_health += 100
		base_defence += 3
		base_crit += 2
		base_dam_crit += 3
		base_speed += 10
		base_mana += 20
		base_mana_regen += 0.5
		base_health_reg += 0.5
		print("level up")
		update_stats()
		get_node("/root/World/Player/CanvasLayer/Skill_tree").points += 1
		get_node("/root/World/Player/CanvasLayer/Skill_tree/CanvasModulate/Points").text = str(get_node("/root/World/Player/CanvasLayer/Skill_tree").points)
	get_node("/root/World/Player").update_xp()

func add_gold(amount):
	gold += amount
	var j = ""
	for n in range(7-len(str(gold))):
		j += "0"
	get_node("/root/World/Player/CanvasLayer/Gold/Label2").text = j + str(gold)

func go_to(data,n):#set to go to new world
	if not n in map_been:
		map_been.append(int(n))
	if data:
		get_tree().change_scene("res://Scenes/World.tscn")
		yield(get_tree(),"idle_frame")
		var world = get_node("/root/World")
		var enemy_scenes = []
		for m in data.monsters:
			enemy_scenes.append(m.input)
		var extra = []
		for e in data.extra:
			extra.append(e.input)
		world.create_world(data.max_size,data.rooms,data.tile,extra)
		world.create_enemys(data.max_size,data.amount_monster,enemy_scenes,data.min_level,data.max_level)
	else:
		get_tree().change_scene("res://Scenes/Town.tscn")

func create_gold(position,level):
	if randi() % 3 == 0: #1/3 change for gold to drop
		var drop_gold_instance = load("res://Scenes/Gold_pick_up.tscn").instance()
		drop_gold_instance.position = position
		drop_gold_instance.amount = randi() % 10*level + 2*level
		var pos = Vector2(50-randi() % 100,50-randi() % 100)
		if get_node("/root/World/Nav/Title").get_cellv(get_node("/root/World/Nav/Title").world_to_map(pos + position)) == 0:
			drop_gold_instance.position = pos + position
		else:
			drop_gold_instance.position = position
		get_node("/root/World/Gold").add_child(drop_gold_instance)

func pick_name():
	return [
		"Soulsiphon",
		"Blightspore",
		"Soulkeeper",
		"Sunlight",
		"Holy Aspect",
		"Champion Ornament",
		"Thundersoul Stone",
		"Scar, Trinket of the Caged Mind",
		"Mercy, Hope of Silence",
		"Nirvana, Aspect of Desecration",
		"Randy Ortain",
		"Peenexcalibur",
		"Mini sucktion cup man",
	][randi()%13]

func create_drop(position):
	var world = get_node("/root/World")
	var rare = PlayerData.run_random({1000:0,120:1,40:2,10:3,4:4,1:5},world.enemys_killed) #get which rear
	for n in range(len(get_node("/root/World").enemys_killed)):
		world.enemys_killed[n] += 1
	get_node("/root/World").enemys_killed[rare] = 0
		#{"max":1000,range(250,1000):0,range(100,250):1,range(40,100):2,range(13,40):3,range(2,13):4,range(2):5})
	if rare == 0: #return if there isn't a drop
		return
	
	var item = Resource.new()
	item.set_script(preload("res://Resource script/Item.gd"))
	item.stats = []
	for n in range(rare + 1):#set item stats and data
		var stat = Resource.new()
		stat.set_script(preload("res://Resource script/Stats.gd"))
		stat.type = randi()%8
		stat.change = randi()%2
		stat.amount = round((float(randi()%10)+1)*rare*(randi()%5+5)/10)
		item.stats.append(stat)
	item.name = pick_name()
	item.color = ["",Color(1,1,1),Color(0,1,0),Color(0,0,1),Color("C947F5"),Color("FF6600")][rare]
	item.type = randi()%5
	item.rare = rare
	
	var drop_item_instance = preload("res://Scenes/Drop_items.tscn").instance()
	drop_item_instance.data = item
	var pos = Vector2(50-randi() % 100,50-randi() % 100)
	if get_node("/root/World/Nav/Title").get_cellv(get_node("/root/World/Nav/Title").world_to_map(pos + position)) == 0:
		drop_item_instance.position = pos + position
	else:
		drop_item_instance.position = position
	drop_item_instance.get_node("Icon").modulate = item.color
	get_node("/root/World/Drop_items").add_child(drop_item_instance)
