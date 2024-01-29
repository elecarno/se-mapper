extends Control

var datatype = "planet"
var data_idx = 0

@onready var name_edit: LineEdit = get_node("name_edit")
@onready var prop_names: Label = get_node("prop_names")
@onready var prop_labels: Label = get_node("prop_label")
@onready var colour_picker_button: ColorPickerButton = get_node("colour_picker_button")
@onready var map = get_parent().get_parent().get_parent()

signal update_display

func initialise(type: String, i: int):
	datatype = type
	data_idx = i
	
	match datatype:
		"planet":
			var objectdata = gpsdata.planets[data_idx]
			name_edit.text = str(objectdata[0])
			prop_names.text = "Position\nRadius\nAtm. Radius\nGravity"
			prop_labels.text = str(objectdata[1]) + "\n" + str(objectdata[2]/1000) + "km\n" + str(objectdata[4]/1000) + "km\n" + str(objectdata[5]) + "g" 
			var colvec = objectdata[-1]
			colour_picker_button.color = Color(colvec.x, colvec.y, colvec.z, 1.0)
		"station":
			var objectdata = gpsdata.stations[data_idx]
			name_edit.text = str(objectdata[3])
			prop_names.text = "Position"
			prop_labels.text = str(objectdata[1])
			var colvec = objectdata[-1]
			colour_picker_button.color = Color(colvec.x, colvec.y, colvec.z, 1.0)
		"asteroid":
			var objectdata = gpsdata.asteroids[data_idx]
			name_edit.text = str(objectdata[0])
			prop_names.text = "Position"
			prop_labels.text = str(objectdata[1])
			var colvec = objectdata[-1]
			colour_picker_button.color = Color(colvec.x, colvec.y, colvec.z, 1.0)
	
	visible = true

func _process(delta):
	if !visible: return
	
	match datatype:
		"planet":
			var objectdata = gpsdata.planets[data_idx]
			objectdata[0] = name_edit.text
			var colvec_pick = colour_picker_button.color
			var colvec_data: Vector3 = Vector3(colvec_pick.r, colvec_pick.g, colvec_pick.b)
			objectdata[-1] = colvec_data
			gpsdata.planets[data_idx] = objectdata
		"station":
			var objectdata = gpsdata.stations[data_idx]
			objectdata[3] = name_edit.text
			var colvec_pick = colour_picker_button.color
			var colvec_data: Vector3 = Vector3(colvec_pick.r, colvec_pick.g, colvec_pick.b)
			objectdata[-1] = colvec_data
			gpsdata.stations[data_idx] = objectdata
		"asteroid":
			var objectdata = gpsdata.asteroids[data_idx]
			objectdata[0] = name_edit.text
			var colvec_pick = colour_picker_button.color
			var colvec_data: Vector3 = Vector3(colvec_pick.r, colvec_pick.g, colvec_pick.b)
			objectdata[-1] = colvec_data
			gpsdata.asteroids[data_idx] = objectdata

func _on_name_edit_text_submitted(new_text):
	emit_signal("update_display")
	map.update_object_buttons()

func _on_colour_picker_button_color_changed(color):
	emit_signal("update_display")
