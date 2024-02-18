class_name map_controller
extends Node3D

@onready var planet_scene: PackedScene = preload("res://scenes/planet.tscn")
@onready var station_scene: PackedScene = preload("res://scenes/station.tscn")
@onready var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")
@onready var map_obj_button_scene: PackedScene = preload("res://scenes/map_obj_button.tscn")

@onready var cel_shader: Resource = preload("res://shaders/cel_shader.tres")
@onready var station_shader: Resource = preload("res://shaders/station_shader.tres")

@onready var planets_holder = get_node("h_planets")
@onready var stations_holder = get_node("h_stations")
@onready var asteroids_holder = get_node("h_asteroids")
@onready var obj_list = get_node("canvas_layer/map_menus/objects_menu/scroll/vbox")

func spawn_world_objects():
	get_node("camera_controller").world_loaded = true
	get_node("camera_controller/lines").world_loaded = true
	
	# planets
	for i in range(0, gpsdata.planets.size()):
		spawn_planet(i)
	
	# stations
	for i in range(0, gpsdata.stations.size()):
		spawn_station(i)
	
	# Asteroids
	#for i in range(0, gpsdata.asteroids.size()):
		#spawn_asteroid(i)
		
	update_object_buttons()
		
func spawn_planet(i: int):
	var planet: map_object = planet_scene.instantiate()
	planet.data_idx = i
	
	var loc = gpsdata.get_planet_center(gpsdata.planets[i][1], gpsdata.planets[i][2])
	var material: ShaderMaterial = cel_shader.duplicate()
	var colvec = gpsdata.planets[i][-1]
	material.set_shader_parameter("color", Vector4(colvec.x, colvec.y, colvec.z, 1.0))
	
	planet.get_node("model").set_surface_override_material(0, material)
	planet.transform.origin = loc
	
	planets_holder.add_child(planet)
		
func spawn_station(i: int):
	var station: map_object = station_scene.instantiate()
	station.data_idx = i
	
	var loc = gpsdata.stations[i][1]/1000
	var material: ShaderMaterial = station_shader.duplicate()
	var colvec = gpsdata.stations[i][-1]
	material.set_shader_parameter("color", Vector4(colvec.x, colvec.y, colvec.z, 1))
	
	station.get_node("model").set_surface_override_material(0, material)
	station.transform.origin = loc
	station.object_name = str(gpsdata.stations[i][3])
	station.faction = gpsdata.stations[i][4]
	station.type = gpsdata.stations[i][5]
	
	stations_holder.add_child(station)
		
func spawn_asteroid(i: int):
	var asteroid: map_object = asteroid_scene.instantiate()
	asteroid.data_idx = i
	
	var loc = gpsdata.asteroids[i][1]/1000
	
	asteroid.transform.origin = loc
	asteroid.object_name = str(gpsdata.asteroids[i][0])
	
	asteroids_holder.add_child(asteroid)
		
func wipe_map():
	for i in range(0, planets_holder.get_child_count()):
		planets_holder.get_child(i).queue_free()
	for i in range(0, stations_holder.get_child_count()):
		stations_holder.get_child(i).queue_free()
	for i in range(0, asteroids_holder.get_child_count()):
		asteroids_holder.get_child(i).queue_free()
	
func update_object_buttons():
	print("objects list refreshed")
	for i in range(0, obj_list.get_child_count()):
		obj_list.get_child(i).queue_free()
		
	spawn_object_buttons(gpsdata.planets, "planet")
	spawn_object_buttons(gpsdata.stations, "station")
	spawn_object_buttons(gpsdata.asteroids, "asteroid")
		
func spawn_object_buttons(data_array: Array, datatype: String):
	for i in range(0, data_array.size()):
		var button = map_obj_button_scene.instantiate()
		
		button.name = datatype + ": " + str(i)
		button.datatype = datatype
		button.data_idx = i
		
		obj_list.add_child(button)
	
func _process(_delta):
	if Input.is_action_just_pressed("toggle_asteroids"):
		asteroids_holder.visible = !asteroids_holder.visible
		
	if Input.is_action_just_pressed("keybinds"):
		get_node("canvas_layer/keybinds").visible = !get_node("canvas_layer/keybinds").visible
		
	if Input.is_action_just_pressed("tab") and !get_node("canvas_layer/file_manager").visible:
		get_node("canvas_layer").visible = !get_node("canvas_layer").visible
