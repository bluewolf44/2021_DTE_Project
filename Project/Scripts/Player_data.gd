extends Node

var health = 12000
var current_health = 12000
var attack = 5
var defence = 4
var crit = 5
var dam_crit = 5
var speed = 300
var mana = 100
var mana_current = 100
var mana_regen = 5

var base_health = 12000
var base_attack = 5
var base_defence = 4
var base_crit = 5
var base_dam_crit = 5
var base_speed = 300
var base_mana = 100
var base_mana_regen = 3

var add_health = 0
var add_attack = 0
var add_defence = 0
var add_crit = 0
var add_dam_crit = 0
var add_speed = 0
var add_mana = 0
var add_mana_regen = 0

var per_health = 0
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

var lvl = 1
var current_xp = 0
var xp_to_next = 100

var action_hold = [load("res://Resoures/Fire_ball2.tres"),load("res://Resoures/Blue_Flame.tres"),load("res://Resoures/Slash.tres")]

func _ready():
	for n in range(60):
		inventory.append(null)

func add_item(data):
	for n in range(60):
		if not inventory[n]:
			inventory[n] = data
			break

func remove_item(data):
	inventory[inventory.find(data)] = null

func run_random(data):# data = {change:answer,120:1,40:2,10:3,4:4,1:5}
	var total = 0
	var hold = []
	for d in data:
		total += d
		hold.append({"rare":total,"res":data[d]})
		
	var rand = randi() % total
	for h in hold:
		if rand <= h["rare"]:
			return h["res"]

func update_stats():
	for n in ["add","per"]:
		for i in ["attack","health","defence","speed","crit","dam_crit","mana","mana_regen"]:
			self[n + "_"+ i] = 0
	var total = skill_stats
	for e in equited:
		if equited[e]:
			for stat in equited[e].stats:
				total.append(stat)
	
	for stat in total:
		self[["add","per"][stat.change]+"_"+["attack","health","defence","speed","crit","dam_crit","mana","mana_regen"][stat.type]] += stat.amount
	
	for i in ["attack","health","defence","speed","crit","dam_crit","mana","mana_regen"]:
		self[i] = round((self["per_" + i]/100+1)*self["base_" + i] + self["add_" + i])
		print(i,self[i])
	if get_node("/root/World/Player"):
		get_node("/root/World/Player").updata_stats()

func gain_xp(number):
	current_xp += number
	while current_xp >= xp_to_next:
		current_xp -= xp_to_next
		xp_to_next = 5*lvl*lvl+95
		lvl += 1
		base_attack += 2
		base_health += 1000
		base_defence += 3
		base_crit += 2
		base_dam_crit += 3
		base_speed += 10
		base_mana += 20
		base_mana_regen += 1
		print("level up")
		update_stats()
	get_node("/root/World/Player").update_xp()

func add_gold(amount):
	gold += amount
	var j = ""
	for n in range(7-len(str(gold))):
		j += "0"
	get_node("/root/World/Player/CanvasLayer/Gold/Label2").text = j + str(gold)
