class_name map_object
extends Node3D

const show_colour: Color = Color(1, 1, 1, 1)
const hide_colour: Color = Color(1, 1, 1, 0)

var label_hide_distance: int = 500
@export var scale_labels: bool = false
@export var scale_size: bool = false
@export var topdown_scale: Vector3
@export var freecam_scale: Vector3

var object_name: String = "Unknown"

@onready var labels: Node3D = get_node("labels")
@export var name_label: Label3D
@export var type_label: Label3D
@export var prop_label: Label3D

@onready var cam_controller = get_parent().get_parent().get_node("camera_controller")
@onready var freecam = cam_controller.get_node("freecam")

func _process(_delta):
	if cam_controller.view == 0:
		if scale_size: scale = topdown_scale
	if cam_controller.view == 1:
		if scale_size: scale = freecam_scale
		
		var dist_to_cam = position.distance_to(freecam.position)
		var scale_factor = sqrt(dist_to_cam)
		var scale_value = 1 * scale_factor
		
		labels.rotation = Vector3(freecam.rotation.x, freecam.rotation.y, freecam.rotation.z)
		if scale_labels:
			labels.scale = Vector3(scale_value/2, scale_value/2, scale_value/2)
		
		if dist_to_cam < label_hide_distance or cam_controller.show_all_labels:
			name_label.modulate = show_colour
			if prop_label != null:
				prop_label.modulate = show_colour
			if type_label != null:
				type_label.modulate = show_colour
		else:
			name_label.modulate = hide_colour
			if prop_label != null:
				prop_label.modulate = hide_colour
			if type_label != null:
				type_label.modulate = hide_colour
