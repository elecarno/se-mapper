extends map_object

var faction: String = "Unknown"
var type: String = "Space Station"

func _ready():
	if faction != "N/A":
		name_label.text = "[" + faction + "] " + object_name
		type_label.text = type
	else:
		name_label.text = ""
		type_label.text = ""
