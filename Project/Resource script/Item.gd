extends Resource
class_name Item

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"rare","input":"int"},
	{"name":"sprite","input":"tex"},
	{"name":"stats","input":"create","other":["Stats"]},
]

enum enum_type{
	CHEST
	RING
	LEGS
	HEAD
	WEAPON
}

export var name = ""
export var rare = 1
export(enum_type) var type
export(Array,Resource) var stats = []
export(Texture) var sprite

var color = Color(1,1,1)
