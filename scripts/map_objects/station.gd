extends map_object

var faction: String = "Unknown"
var type: String = "Space Station"



func _ready():
	update_display()
	object_editor.connect("update_display", update_display)
	
func update_display():
	var objectdata = gpsdata.stations[data_idx]
	
	var material: ShaderMaterial = station_shader.duplicate()
	var colvec = objectdata[-1]
	material.set_shader_parameter("color", Vector4(colvec.x, colvec.y, colvec.z, 1))
	get_node("model").set_surface_override_material(0, material)
	
	object_name = objectdata[3]
	
	if faction != "N/A":
		name_label.text = "[" + faction + "] " + object_name
		type_label.text = type
	else:
		name_label.text = ""
		type_label.text = ""
