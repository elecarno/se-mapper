class_name c_xml_parser
extends Control

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
					current_planet.append(Vector3(0.21, 0.48, 0.65))
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
					current_station.append(Vector3(1.0, 1.0, 1.0))
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
					current_asteroid.append(Vector3(0.92, 0.65, 0.20))
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
