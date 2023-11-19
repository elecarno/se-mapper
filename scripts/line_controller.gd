extends Node3D

@onready var cam_controller:camera_contoller = get_parent()
@onready var stations = get_parent().get_parent().get_node("stations")
@onready var console = get_parent().get_parent().get_node("canvas_layer/console")

@onready var mapline = preload("res://mapline.tscn")

var selection_1: Node3D = null

func sort_closest(a, b):
	return a.position < b.position

func order_stations():
	var station_list = stations.get_children()
	station_list.sort_custom(sort_closest)
	return station_list

func get_station():
	var closest_station = null
	var shortest_distance = INF
	for station in stations.get_children():
		if not is_instance_valid(station):
			continue
		var distance = cam_controller.active_cam.position.distance_to(station.position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_station = station
	return closest_station

func _process(_delta):
	var nearest = get_station()
	
	if selection_1 == null:
		if Input.is_action_just_pressed("select_nearest"):
			selection_1 = nearest
			print("selection_1: " + str(nearest.position) + " | " + str(nearest.gridname))
		console.text = "nearest: " + str(nearest.gridname)
	else:
		var pos1 = selection_1.position
		var pos2 = nearest.position
		var dist = sqrt(pow((pos2.x - pos1.x), 2) + pow((pos2.y - pos1.y), 2) + pow((pos2.z - pos1.z), 2))
		var dist_str = " (%.01fkm)" % [dist]
		console.text = "(draw route) from: " + str(selection_1.gridname) + ", to: " + str(nearest.gridname) + dist_str
		if Input.is_action_just_pressed("select_nearest"):
			spawn_line(selection_1.position, nearest.position)
			print("drawn line to: " + str(nearest.position) + " | " + str(nearest.gridname))
			selection_1 = null
			
	if Input.is_action_just_pressed("show_all"):
		for i in range(0, stations.get_child_count()):
			if nearest.position != stations.get_child(i).position:
				spawn_line(nearest.position, stations.get_child(i).position)
				
	if Input.is_action_just_pressed("cancel"):
		selection_1 = null
		console.text = "from: " + str(nearest.gridname)
		for i in range(0, get_child_count()):
			get_child(i).queue_free()
			
	if Input.is_action_just_pressed("show_trade"):
		get_node("trade").visible = !get_node("trade").visible

func spawn_line(pos_1: Vector3, pos_2: Vector3):
	var line = mapline.instantiate()
	line.pos1 = pos_1
	line.pos2 = pos_2
	add_child(line)
