extends Node3D

var yaw: float = 0.0
var pitch: float = 0.0

var yaw_sensitivity: float = 0.15
var pitch_sensitivity: float = 0.15

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var pitch_max: float = 75
var pitch_min: float = -75

@onready var yaw_node: Node3D = get_node("cam_yaw")
@onready var pitch_node: Node3D = get_node("cam_yaw/cam_pitch")

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += -event.relative.y * pitch_sensitivity
		
func _physics_process(delta):
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
	
	pitch = clamp(pitch, pitch_min, pitch_max)
