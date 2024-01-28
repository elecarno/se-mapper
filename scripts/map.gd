extends Node3D

@onready var planet_scene: PackedScene = preload("res://planet.tscn")
@onready var station_scene: PackedScene = preload("res://station.tscn")
@onready var asteroid_scene: PackedScene = preload("res://asteroid.tscn")

@onready var cel_shader: Resource = preload("res://cel_shader.tres")
@onready var station_shader: Resource = preload("res://station_shader.tres")

@onready var planets_holder = get_node("planets")
@onready var stations_holder = get_node("stations")
@onready var asteroids_holder = get_node("asteroids")

func init_world():
	get_node("camera_controller").world_loaded = true
	get_node("camera_controller/lines").world_loaded = true
	
	# planets
	for i in range(0, gpsdata.planets.size()):
		var loc = gpsdata.get_planet_center(gpsdata.planets[i][1], gpsdata.planets[i][2])
		var planet: Node3D = planet_scene.instantiate()
		planet.transform.origin = loc
		planet.radius = (gpsdata.planets[i][2]/1000)
		var material: ShaderMaterial = cel_shader.duplicate()
		material.set_shader_parameter("color", Vector4(0.32, 0.75, 0.38, 1.0))
		planet.get_node("model").set_surface_override_material(0, material)
		planet.pos = loc
		planet.planetname = gpsdata.planets[i][0]
		planet.gravity = gpsdata.planets[i][5]
		planets_holder.add_child(planet)

	# stations
	for i in range(0, gpsdata.stations.size()):
		var loc = gpsdata.stations[i][1]/1000
		var station = station_scene.instantiate()
		station.transform.origin = loc
		station.pos = loc
		station.gridname = str(gpsdata.stations[i][3])
		station.faction = "Unknown"
		station.type = "Station"
		
		var material: ShaderMaterial = station_shader.duplicate()
		material.set_shader_parameter("color", Vector4(1,1,1,1))
		station.get_node("model").set_surface_override_material(0, material)
		
		stations_holder.add_child(station)
		
	 # Asteroids
	for i in range(0, gpsdata.asteroids.size()):
		var loc = gpsdata.asteroids[i][1]/1000
		var asteroid = asteroid_scene.instantiate()
		asteroid.transform.origin = loc
		asteroid.pos = loc
		asteroid.resources = gpsdata.asteroids[i][0]
		
		asteroids_holder.add_child(asteroid)
		
func _process(_delta):
	if Input.is_action_just_pressed("toggle_asteroids"):
		get_node("asteroids").visible = !get_node("asteroids").visible
		
	if Input.is_action_just_pressed("keybinds"):
		get_node("canvas_layer/keybinds").visible = !get_node("canvas_layer/keybinds").visible 
