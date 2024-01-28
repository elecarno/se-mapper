extends map_object

var radius: float = 0.0
var gravity: float = 0.0

func _ready():
	name_label.text = object_name
	get_node("model").scale = Vector3(radius*2, radius*2, radius*2)
	var grav_str = "%.01f" % [gravity]
	prop_label.text = grav_str + "g, ⌀" + str(radius*2) + "km"
	labels.position = Vector3(0, -radius - 20, 0)

