extends Node3D

var pos: Vector3 = Vector3(0, 0, 0)
var planetname: String = "Unnamed"
var radius: float = 0.0
var gravity: float = 0.0

@onready var labels = get_node("labels")
@onready var name_label = get_node("labels/name")
@onready var prop_label = get_node("labels/properties")

@onready var cam_controller = get_parent().get_parent().get_node("camera_controller")
@onready var freecam = cam_controller.get_node("freecam")

func _ready():
	get_node("model").scale = Vector3(radius*2, radius*2, radius*2)
	name_label.text = planetname
	var grav_str = "%.01f" % [gravity]
	prop_label.text = grav_str + "g, ⌀" + str(radius*2) + "km"
	labels.position = Vector3(0, -radius - 20, 0)

func _process(_delta):
	if cam_controller.view == 0:
		pass
	if cam_controller.view == 1:
		var dist_to_cam = position.distance_to(freecam.position)
		#var scale_factor = sqrt(dist_to_cam)
		#var scale_value = 1 * scale_factor
		
		labels.rotation = Vector3(freecam.rotation.x, freecam.rotation.y, freecam.rotation.z)
		#labels.scale = Vector3(-scale_value/2, scale_value/2, scale_value/2)
		if dist_to_cam < 500 or cam_controller.show_all_labels:
			name_label.modulate = Color(1, 1, 1, 1)
			prop_label.modulate = Color(1, 1, 1, 1)
		else:
			name_label.modulate = Color(1, 1, 1, 0)
			prop_label.modulate = Color(1, 1, 1, 0)

