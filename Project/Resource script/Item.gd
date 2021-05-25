extends Resource
class_name Item

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"description","input":"str"},
	{"name":"sprite","input":"tex"},
	{"name":"stats","input":"create","other":["Stats"]},
]

export var name = ""
export var description = ""
export(Array,Resource) var stats = []
export(Texture) var sprite

