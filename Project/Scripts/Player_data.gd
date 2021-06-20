extends Node

var health = 1200000
var attack = 69
var defence = 4
var crit = 2
var speed = 300

var base_health = 1200
var base_attack = 69
var base_defence = 4
var base_crit = 2
var base_speed = 300

var add_health = 0
var add_attack = 0
var add_defence = 0
var add_crit = 0
var add_speed = 0

var per_health = 0
var per_attack = 0
var per_defence = 0
var per_crit = 0
var per_speed = 0

var inventory = []
var equited = {}

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

func run_random(data):# data = {"max":100,range(2):"answer",range(3,8):"anweser"....
	var numb = randi() % data["max"]
	data.erase("max")
	for d in data:
		if numb in d:
			return data[d]

func update_stats():
	for n in ["add","per"]:
		for i in ["attack","health","defence","speed","crit"]:
			self[n + "_"+ i] = 0
	
	for e in equited:
		if equited[e]:
			for stat in equited[e].stats:
				self[["add","per"][stat.change]+"_"+["attack","health","defence","speed","crit",][stat.type]] += stat.amount
	
	for i in ["attack","health","defence","speed","crit"]:
		self[i] = (round(self["per_" + i]/100+1)*self["base_" + i] + self["add_" + i])
		print(i,self[i])
