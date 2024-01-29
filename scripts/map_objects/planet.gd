extends map_object

var radius: float = 0.0
var atm_radius: float = 0.0
var gravity: float = 0.0

func _ready():
	update_display()
	object_editor.connect("update_display", update_display)

func update_display():
	var objectdata = gpsdata.planets[data_idx]
	
	var material: ShaderMaterial = cel_shader.duplicate()
	var colvec = objectdata[-1]
	material.set_shader_parameter("color", Vector4(colvec.x, colvec.y, colvec.z, 1))
	get_node("model").set_surface_override_material(0, material)
	
	object_name = objectdata[0]
	radius = objectdata[2]/1000
	atm_radius = objectdata[4]
	gravity = objectdata[5]
	
	name_label.text = object_name
	get_node("model").scale = Vector3(radius*2, radius*2, radius*2)
	var grav_str = "%.01f" % [gravity]
	prop_label.text = grav_str + "g, ⌀" + str(radius*2) + "km"
	labels.transform.origin = Vector3(0, (-radius/10)*1.2, 0)
