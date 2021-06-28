extends Resource
class_name Enemy

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"xp","input":"int"},
	{"name":"health","input":"int"},
	{"name":"speed","input":"int"},
	{"name":"distance","input":"int"},
	{"name":"attack_speed","input":"float"},
	{"name":"attack","input":"create_one","other":["Enemy_attack"]},
	]

export var name = "name"
export var health = 100
export var xp = 1
export var speed = 300
export var distance = 100
export var attack_speed = 0.5
export(Resource) var attack
