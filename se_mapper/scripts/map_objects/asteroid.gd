extends map_object

func _ready():
	update_display()
	object_editor.connect("update_display", update_display)

func update_display():
	var objectdata = gpsdata.asteroids[data_idx]
	
	var material: ShaderMaterial = cel_shader.duplicate()
	var colvec = objectdata[-1]
	material.set_shader_parameter("color", Vector4(colvec.x, colvec.y, colvec.z, 1))
	get_node("model").set_surface_override_material(0, material)
	
	object_name = objectdata[0]
	
	name_label.text = object_name
