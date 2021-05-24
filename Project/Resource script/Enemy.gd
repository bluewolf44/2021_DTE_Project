extends Resource
class_name Enemy

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"health","input":"int"},
	{"name":"speed","input":"int"},
	{"name":"attack","input":"create_one","other":["Enemy_attack"]},
	]

export var name = "name"
export var health = 100
export var speed = 300
export(Resource) var attack
