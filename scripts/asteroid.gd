extends Node3D

var pos: Vector3 = Vector3(0, 0, 0)
var resources: String = "N/A"

@onready var labels = get_node("labels")
@onready var name_label = get_node("labels/name")

@onready var cam_controller = get_parent().get_parent().get_node("camera_controller")
@onready var freecam = cam_controller.get_node("freecam")

func _ready():
	name_label.text = resources

func _process(_delta):
	if cam_controller.view == 0:
		get_node("model").scale = Vector3(5, 5, 5)
	if cam_controller.view == 1:
		var dist_to_cam = position.distance_to(freecam.position)
		var scale_factor = sqrt(dist_to_cam)
		#var scale_value = 1 * scale_factor
		get_node("model").scale = Vector3(2, 2, 2)
		
		labels.rotation = Vector3(freecam.rotation.x, freecam.rotation.y, freecam.rotation.z)
		#labels.scale = Vector3(-scale_value/2, scale_value/2, scale_value/2)
		if dist_to_cam < 500 or cam_controller.show_all_labels:
			name_label.modulate = Color(1, 1, 1, 1)
		else:
			name_label.modulate = Color(1, 1, 1, 0)

