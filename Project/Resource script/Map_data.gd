extends Resource
class_name Map_data
var type = "Map_data"

var create_inputs = [
	{"name":"name","input":"str"},
	{"name":"min_level","input":"int"},
	{"name":"max_level","input":"int"},
	{"name":"tile","input":"str"},
	{"name":"max_size","input":"int"},
	{"name":"rooms","input":"int"},
	{"name":"amount_monster","input":"int"},
	{"name":"monsters","input":"create","other":["String_input"]},
	{"name":"extra","input":"create","other":["String_input"]},
	]

export var name = "name"
export var min_level = 0
export var max_level = 1
export var tile = "plains"
export var max_size = 1
export var rooms = 1
export var amount_monster = 1
export(Array,Resource) var extra = []
export(Array,Resource) var monsters = []
