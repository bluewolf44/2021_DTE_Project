extends Node

var health = 1200000
var attack = 69
var defence = 4
var crit = 2
var speed = 300

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
