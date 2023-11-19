extends Node3D

@onready var planet_scene: PackedScene = preload("res://planet.tscn")
@onready var station_scene: PackedScene = preload("res://station.tscn")
@onready var asteroid_scene: PackedScene = preload("res://asteroid.tscn")

@onready var cel_shader: Resource = preload("res://cel_shader.tres")
@onready var station_shader: Resource = preload("res://station_shader.tres")

@onready var planets_holder = get_node("planets")
@onready var stations_holder = get_node("stations")
@onready var asteroids_holder = get_node("asteroids")

# Called when the node enters the scene tree for the first time.
func _ready():
	# planets
	for i in range(0, gpsdata.planets.size()):
		var loc = gpsdata.convert_gps_to_vector3(gpsdata.planets[i][0])
		var planet: Node3D = planet_scene.instantiate()
		planet.transform.origin = loc
		planet.radius = gpsdata.planets[i][1]
		var material: ShaderMaterial = cel_shader.duplicate()
		material.set_shader_parameter("color", gpsdata.planets[i][2])
		planet.get_node("model").set_surface_override_material(0, material)
		planet.planetnumber = gpsdata.get_gps_name(gpsdata.planets[i])
		planet.pos = loc
		planet.planetfile = gpsdata.planets[i][3]
		planet.planetname = gpsdata.planets[i][4]
		planet.gravity = gpsdata.planets[i][5]
		planets_holder.add_child(planet)

	# stations
	for i in range(0, gpsdata.stations.size()):
		var loc = gpsdata.convert_gps_to_vector3(gpsdata.stations[i][0])
		var station = station_scene.instantiate()
		station.transform.origin = loc
		station.pos = loc
		var stationdata = gpsdata.get_station_data(gpsdata.stations[i])
		station.gridname = stationdata[0]
		station.faction = stationdata[1]
		station.type = stationdata[2]
		
		var material: ShaderMaterial = station_shader.duplicate()
		material.set_shader_parameter("color", gpsdata.factions[gpsdata.stations[i][1]])
		station.get_node("model").set_surface_override_material(0, material)
		
		stations_holder.add_child(station)
		
	# Asteroids
	for i in range(0, gpsdata.asteroids.size()):
		var loc = gpsdata.convert_gps_to_vector3(gpsdata.asteroids[i][0])
		var asteroid = asteroid_scene.instantiate()
		asteroid.transform.origin = loc
		asteroid.pos = loc
		asteroid.resources = gpsdata.get_gps_name(gpsdata.asteroids[i])
		
		asteroids_holder.add_child(asteroid)
		
func _process(_delta):
	if Input.is_action_just_pressed("toggle_rings"):
		get_node("rings").visible = !get_node("rings").visible
		
	if Input.is_action_just_pressed("toggle_asteroids"):
		get_node("asteroids").visible = !get_node("asteroids").visible
		
	if Input.is_action_just_pressed("keybinds"):
		get_node("canvas_layer/keybinds").visible = !get_node("canvas_layer/keybinds").visible 
