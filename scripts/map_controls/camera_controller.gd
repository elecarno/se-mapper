class_name camera_contoller
extends Node3D

var world_loaded: bool = false

@onready var top_down_cam: Camera3D = get_node("top_down_cam")
@onready var freecam: Camera3D = get_node("freecam")
@onready var orbit_cam: Camera3D = get_node("orbit_cam/cam_yaw/cam_pitch/cam")

@onready var lines = get_node("lines")

var show_all_labels: bool = false

var view: int = 0 # 0 = top down, 1 = free cam, 2 = orbit
var active_cam: Camera3D

func _ready():
	active_cam = top_down_cam

func _process(_delta):
	if !world_loaded:
		return
	
	if view == 0:
		if Input.is_action_pressed("alt_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if view == 1:
		if Input.is_action_pressed("alt_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if view == 2:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("switch_view"):
		view += 1
		if view > 1:
			view = 0
			
		if view != 2:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		switch_view(view)
		
	if Input.is_action_just_pressed("toggle_labels"):
		show_all_labels = !show_all_labels
		
#	lines.get_node("line2d").clear_points()
#	lines.get_node("line2d").add_point(active_cam.unproject_position(Vector3(0, 0, 0)))
#	lines.get_node("line2d").add_point(active_cam.unproject_position(Vector3(350, 50, 350)))
		
func switch_view(view_num: int):
	if view_num == 0:
		active_cam = top_down_cam
		top_down_cam.current = true
		freecam.current = false
		orbit_cam.current = false
	if view == 1:
		active_cam = freecam
		top_down_cam.current = false
		freecam.current = true
		orbit_cam.current = false
	if view == 2:
		active_cam = orbit_cam
		top_down_cam.current = false
		freecam.current = false
		orbit_cam.current = true
