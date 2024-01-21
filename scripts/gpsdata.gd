extends Node

var planets: Array = [] # [name, position, radius, has_atmos, atmos_radius, gravity]
var asteroids: Array = [] # [name, position]
var stations: Array = [] # [id, position, is_static, display_name]

func get_planet_center(corner_pos: Vector3, dimension: float) -> Vector3:
	var x = dimension + corner_pos.x
	var y = dimension + corner_pos.y
	var z = dimension + corner_pos.z
	var loc: Vector3 = Vector3(x/1000, y/1000, z/1000)
	return loc

func convert_gps_to_vector3(gps: String):
	var gps_split: Array = gps.split(":")
	var x: float = float(gps_split[2])/1000
	var y: float = float(gps_split[3])/1000
	var z: float = float(gps_split[4])/1000
	var converted_gps: Vector3 = Vector3(x, y, z)
	return converted_gps
	
func get_station_data(item: Array):
	var gps_split: Array = item[0].split(":")
	var gridname = gps_split[1]
	var faction = item[1]
	var type = "Space Station"
	if item.size() > 2:
		type = item[2]
	
	return [gridname, faction, type]

func get_gps_name(item: Array):
	var gps_split: Array = item[0].split(":")
	var gpsname = gps_split[1]
	
	return gpsname
	
func load_save(path: String):
	#parser_test()
	planets = xml_get_planets(path)
	stations = xml_get_stations(path)
	#asteroids = xml_get_asteroids(path)
	print(planets)
	print(stations)
	#print(asteroids)
	if planets != []:
		get_parent().get_node("/root/map").init_world()
		get_parent().get_node("/root/map/canvas_layer/start_screen").visible = false
	
func xml_get_planets(file: String) -> Array:
	var parser = XMLParser.new()
	parser.open(file)

	var planets_found: Array = []

	var current_element: String
	var current_planet: Array
	var is_reading_planet: bool
	while parser.read() == OK:
		match parser.get_node_type():
			XMLParser.NODE_ELEMENT:
				current_element = parser.get_node_name()
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					
				if attributes_dict.has("xsi:type") and attributes_dict["xsi:type"] == "MyObjectBuilder_Planet":
					is_reading_planet = true
					
				if is_reading_planet:
					if current_element == "Position":
						current_planet.append(attributes_dict)
			XMLParser.NODE_TEXT:
				var data = parser.get_node_data()
				
				if is_reading_planet:
					if current_element == "Name":
						var name_data_split = data.split("-")
						current_planet.append(name_data_split[0])
					if current_element == "Radius":
						current_planet.append(data)
					if current_element == "HasAtmosphere":
						current_planet.append(data)
					if current_element == "AtmosphereRadius":
						current_planet.append(data)
					if current_element == "SurfaceGravity":
						current_planet.append(data)
			XMLParser.NODE_ELEMENT_END:
				if parser.get_node_name() == "MyObjectBuilder_EntityBase" and is_reading_planet:
					planets_found.append(clean_array(current_planet))
					current_planet = []
					is_reading_planet = false
	
	return planets_found
	
func xml_get_stations(file: String) -> Array:
	var parser = XMLParser.new()
	parser.open(file)

	var stations_found: Array = []

	var current_element: String
	var current_station: Array
	var is_reading_station: bool
	while parser.read() == OK:
		match parser.get_node_type():
			XMLParser.NODE_ELEMENT:
				current_element = parser.get_node_name()
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					
				if attributes_dict.has("xsi:type") and attributes_dict["xsi:type"] == "MyObjectBuilder_CubeGrid":
					is_reading_station = true
					
				if is_reading_station:
					if current_element == "Position":
						current_station.append(attributes_dict)
			XMLParser.NODE_TEXT:
				var data = parser.get_node_data()
				
				if is_reading_station:
					if current_element == "Name":
						current_station.append(data)
					if current_element == "IsStatic":
						current_station.append(data)
					if current_element == "DisplayName":
						current_station.append(data)
			XMLParser.NODE_ELEMENT_END:
				if parser.get_node_name() == "MyObjectBuilder_EntityBase" and is_reading_station:
					var cleaned_station_array = clean_array(current_station)
					if cleaned_station_array[2] is bool and cleaned_station_array[2] == true:
						stations_found.append(cleaned_station_array)
					#stations_found.append(cleaned_station_array)
					current_station = []
					is_reading_station = false
	
	return stations_found
	
func xml_get_asteroids(file: String) -> Array:
	var parser = XMLParser.new()
	parser.open(file)

	var asteroids_found: Array = []

	var current_element: String
	var current_asteroid: Array
	var is_reading_asteroid: bool
	while parser.read() == OK:
		match parser.get_node_type():
			XMLParser.NODE_ELEMENT:
				current_element = parser.get_node_name()
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					
				if attributes_dict.has("xsi:type") and attributes_dict["xsi:type"] == "MyObjectBuilder_VoxelMap":
					is_reading_asteroid = true
					
				if is_reading_asteroid:
					if current_element == "Position":
						current_asteroid.append(attributes_dict)
			XMLParser.NODE_TEXT:
				var data = parser.get_node_data()
				
				if is_reading_asteroid:
					if current_element == "Name":
						current_asteroid.append(data)
			XMLParser.NODE_ELEMENT_END:
				if parser.get_node_name() == "MyObjectBuilder_EntityBase" and is_reading_asteroid:
					asteroids_found.append(clean_array(current_asteroid))
					current_asteroid = []
					is_reading_asteroid = false
	
	return asteroids_found

func clean_array(array: Array) -> Array:
	var cleaned_array : Array = []
	for i in range(0, array.size()):
		if i == 0:
			cleaned_array.append(array[i])
		elif array[i] is String:
			if !array[i].contains("\r"):
				if str_to_var(array[i]) == null:
					cleaned_array.append(array[i])
				else:
					cleaned_array.append(str_to_var(array[i]))
		elif array[i] is Dictionary:
			if array[i].has("x") and array[i].has("y") and array[i].has("z"):
				var pos_vec: Vector3 = Vector3(float(array[i]["x"]), float(array[i]["y"]), float(array[i]["z"]))
				cleaned_array.append(pos_vec)
		else:
			cleaned_array.append(array[i])
	
	return cleaned_array

func xml_get_data(target_element: String) -> String:
	var parser = XMLParser.new()
	parser.open("example_world.sbs")

	var current_element: String
	while parser.read() == OK:
		match parser.get_node_type():
			XMLParser.NODE_ELEMENT:
				current_element = parser.get_node_name()
			XMLParser.NODE_TEXT:
				if current_element == target_element:
					return parser.get_node_data()
	
	return "-1"
