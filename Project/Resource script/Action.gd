extends Resource
class_name Action

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"description","input":"str"},
	{"name":"time","input":"float"},
	{"name":"sprite","input":"str"},
	{"name":"speed","input":"int"},
	{"name":"cast_time","input":"float"},
	{"name":"icon","input":"tex"},
	{"name":"interact","input":"create","other":["String_input"]},
	{"name":"affect","input":"create","other":["String_input"]},
	{"name":"where","input":"create_one","other":["Where"]},
	{"name":"effects","input":"create","other":["Damage","After_projectile"]},
	]

export var name = "name"
export var time = -1.0
export var cast_time = 1.0
export var speed = 0
export var sprite = ""
export var description = ""
export(Texture) var icon
export(Array,Resource) var interact = []
export(Array,Resource) var affect = []
export(Resource) var where
export(Array,Resource) var effects = []
