extends Line2D

@export var pos1: Vector3
@export var pos2: Vector3

@onready var cam_controller: camera_contoller = get_parent().get_parent()
@onready var dist_label = get_node("dist_label")

func _process(_delta):
	if cam_controller.active_cam.is_position_behind(pos1) or cam_controller.active_cam.is_position_behind(pos2):
		visible = false
		dist_label.visible = false
	else:
		visible = true
		dist_label.visible = true
		set_point_position(0, cam_controller.active_cam.unproject_position(pos1))
		set_point_position(1, cam_controller.active_cam.unproject_position(pos2))
		
		var labelpos = Vector3((pos1.x + pos2.x)/2, (pos1.y + pos2.y)/2, (pos1.z + pos2.z)/2)
		dist_label.position = cam_controller.active_cam.unproject_position(labelpos)
		
		var dist = sqrt(pow((pos2.x - pos1.x), 2) + pow((pos2.y - pos1.y), 2) + pow((pos2.z - pos1.z), 2))
		var dist_str = "%.01f" % [dist]
		dist_label.text = dist_str + "km"
	
