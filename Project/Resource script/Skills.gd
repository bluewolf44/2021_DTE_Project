extends Resource
class_name Skills

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"description","input":"str"},
	{"name":"stats","input":"create","other":["Stats"]},
	{"name":"special","input":"create_one","other":["Action"]},
	]

export var name = ""
export var description = ""
export(Array,Resource) var stats = []
export(Resource) var special
