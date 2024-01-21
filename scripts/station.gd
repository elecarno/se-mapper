extends Node3D

var pos: Vector3 = Vector3(0, 0, 0)
var gridname: String = "Unknown"
var faction: String = "Unknown"
var type: String = "Space Station"

@onready var labels = get_node("labels")
@onready var name_label = get_node("labels/name")
@onready var type_label = get_node("labels/type")

@onready var cam_controller: camera_contoller = get_parent().get_parent().get_node("camera_controller")
@onready var freecam = cam_controller.get_node("freecam")

func _ready():
	if faction != "N/A":
		name_label.text = "[" + faction + "] " + gridname
		type_label.text = type
	else:
		name_label.text = ""
		type_label.text = ""

func _process(_delta):
	if cam_controller.view == 0:
		scale = Vector3(15, 15, 15)
	if cam_controller.view == 1:
		var dist_to_cam = position.distance_to(freecam.position)
		var scale_factor = sqrt(dist_to_cam)
		var scale_value = 1 * scale_factor
		#scale = Vector3(scale_value, scale_value, scale_value)
		scale = Vector3(5, 5, 5)
		
		#labels.look_at(Vector3(freecam.position.x, self.position.y, freecam.position.z))
		labels.rotation = Vector3(freecam.rotation.x, freecam.rotation.y, freecam.rotation.z)
		labels.scale = Vector3(scale_value/2, scale_value/2, scale_value/2)
		if dist_to_cam < 500 or cam_controller.show_all_labels:
			name_label.modulate = Color(1, 1, 1, 1)
			type_label.modulate = Color(1, 1, 1, 1)
		else:
			name_label.modulate = Color(1, 1, 1, 0)
			type_label.modulate = Color(1, 1, 1, 0)

