extends Resource
class_name Item

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"description","input":"str"},
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
export(enum_type) var type
export(Array,Resource) var stats = []
export(Texture) var sprite

