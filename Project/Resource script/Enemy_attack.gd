extends Resource
class_name Enemy_attack
var dont_show = true

var create_inputs = [
	{"name":"time","input":"float"},
	{"name":"distance","input":"int"},
	{"name":"speed","input":"int"},
	{"name":"sprite","input":"str"},
	{"name":"effects","input":"create","other":["Damage","After_projectile"]},
	]

export var effects = []
export var time = 1.0
export var distance = 20
export var speed = 0
export var sprite = "null"

var affect = []
var interact = [{"input":"Player"},{"input":"Wall"}]
var color = "ffffff"
