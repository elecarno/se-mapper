class_name map_obj_button
extends Button

@onready var planet_icon = preload("res://icons/sphere.svg")
@onready var station_icon = preload("res://icons/cube.svg")
@onready var asteroid_icon = preload("res://icons/hexagon.svg")

var datatype = "planet"
var data_idx = 0

func _ready():
	match datatype:
		"planet":
			icon = planet_icon
			text = gpsdata.planets[data_idx][0] + "     "
		"station":
			icon = station_icon
			text = gpsdata.stations[data_idx][3] + "     "
		"asteroid":
			icon = asteroid_icon
			text = gpsdata.asteroids[data_idx][0] + "     "

func _on_pressed():
	get_parent().get_parent().get_parent().get_parent().get_node("object_editor").initialise(datatype, data_idx)

func _on_delete_button_pressed():
	match datatype:
		"planet":
			gpsdata.planets.remove_at(data_idx)
		"station":
			gpsdata.stations.remove_at(data_idx)
		"asteroid":
			gpsdata.asteroids.remove_at(data_idx)
	
	var map = get_parent().get_parent().get_parent().get_parent().map
	map.wipe_map()
	map.spawn_world_objects()
