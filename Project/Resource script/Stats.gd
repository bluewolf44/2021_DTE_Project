extends Resource
class_name Stats
var dont_show = true
var create_inputs = [
	{"name":"type","input":"enum","other":"stat_type"},
	{"name":"change","input":"enum","other":"per_plus"},
	{"name":"amount","input":"float"},
]

enum stat_type{
	DAMAGE
	HEATH
	DEFENCE
	SPEED
	CRIT
}
enum per_plus{
	ADDITION
	PERCENTAGE
}
export(stat_type) var type
export(per_plus) var change
export var amount = 1.0
