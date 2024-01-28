class_name data_manager
extends Control

@onready var xml_parser: xml_parser = get_node("xml_parser")

func save_mapdata(path):
	var data: Dictionary = {"planets": gpsdata.planets, "stations": gpsdata.stations, "asteroids": gpsdata.asteroids}
	var json = JSON.new()
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(data))
	file.close()
	file = null

func load_gamesave(path: String):
	gpsdata.planets = xml_parser.xml_get_planets(path)
	gpsdata.stations = xml_parser.xml_get_stations(path)
	#gpsdata.asteroids = xml_parser.xml_get_asteroids(path)
	print(gpsdata.planets)
	print(gpsdata.stations)
	#print(gpsdata.asteroids)
	if gpsdata.planets != []:
		get_parent().get_node("/root/map").init_world()
		get_parent().get_node("/root/map/canvas_layer/bg").visible = false
		get_parent().get_node("/root/map/canvas_layer/file_manager").visible = false
