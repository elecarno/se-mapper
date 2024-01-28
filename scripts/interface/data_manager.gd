class_name data_manager
extends Control

@onready var xml_parser: xml_parser = get_node("xml_parser")
#@onready var error_label: Label = get_parent().get_node("file_manager/error")
var json = JSON.new()

func save_mapdata(path: String):
	var data: Dictionary = {"planets": gpsdata.planets, "stations": gpsdata.stations, "asteroids": gpsdata.asteroids}
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(data))
	file.close()
	file = null
	
func load_mapdata(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var data: Dictionary = json.parse_string(file.get_as_text())
	for i in data:
		for j in range(0, data[i].size()):
			data[i][j][1] = string_to_vector3(data[i][j][1])
	print(data)
	gpsdata.planets = data["planets"]
	gpsdata.stations = data["stations"]
	#gpsdata.asteroids = data["asteroids"]
	init_world()

func load_gamesave(path: String):
	gpsdata.planets = xml_parser.xml_get_planets(path)
	gpsdata.stations = xml_parser.xml_get_stations(path)
	#gpsdata.asteroids = xml_parser.xml_get_asteroids(path)
	print(gpsdata.planets)
	print(gpsdata.stations)
	#print(gpsdata.asteroids)
	init_world()

func init_world():
	get_parent().get_node("/root/map").spawn_world_objects()
	get_parent().get_node("/root/map/canvas_layer/bg").visible = false
	get_parent().get_node("/root/map/canvas_layer/file_manager").visible = false

func string_to_vector3(string: String) -> Vector3:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector3(int(array[0]), int(array[1]), int(array[2]))

	return Vector3.ZERO
