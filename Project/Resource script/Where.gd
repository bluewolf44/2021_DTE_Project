extends Resource

class_name Where
var dont_show = true

var create_inputs = [
	{"name":"type","input":"enum","other":"input_type"},
	{"name":"amount","input":"int"},
]

enum input_type{
	PLAYER
	MOUSE
}

export(input_type) var type
export var amount = 0
