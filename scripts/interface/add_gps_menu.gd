extends Control

@onready var gps_insert: LineEdit = get_node("gps_insert")
@onready var type_select: OptionButton = get_node("type_select")
@onready var submit_button: Button = get_node("submit_button")
@onready var confirm_label: Label = get_node("confirm_label")
@onready var para_label: Label = get_node("para_label")
@onready var para_1: LineEdit = get_node("para_1")
@onready var para_2: LineEdit = get_node("para_2")
@onready var map: map_controller = get_parent().get_parent().get_parent()

func _process(_delta):
	if type_select.selected == -1:
		submit_button.disabled = true
		submit_button.text = "Select type to add GPS"
		para_label.visible = false
		para_1.visible = false
		para_2.visible = false
	elif !gpsdata.check_is_gps(gps_insert.text):
		submit_button.disabled = true
		submit_button.text = "Invalid GPS"
		para_label.visible = false
		para_1.visible = false
		para_2.visible = false
	else:
		submit_button.disabled = false
		para_label.visible = true
		para_1.visible = true
		para_2.visible = true

func _on_type_select_item_selected(_index):
	match type_select.selected:
		0:
			submit_button.text = "Add GPS as Planet"
			para_label.text = "Radius\nGravity"
			para_1.placeholder_text = "Insert Radius"
			para_1.text = "60000"
			para_2.placeholder_text = "Insert Gravity"
			para_2.text = "1.0"
		1:
			submit_button.text = "Add GPS as Grid"
			para_label.text = "Faction\nType"
			para_1.placeholder_text = "Insert Faction"
			para_1.text = "Unknown"
			para_2.placeholder_text = "Insert Type"
			para_2.text = "Station"
		2:
			submit_button.text = "Add GPS as Asteroid"

func _on_submit_button_pressed():
	var gps = gps_insert.text
	match type_select.selected:
		0:
			# [name, position, radius, has_atmos, atmos_radius, gravity]
			var new_planet: Array = []
			new_planet.append(gpsdata.get_gps_name(gps)) # name
			new_planet.append(gpsdata.convert_gps_to_vector3(gps)) # pos
			
			if str_to_var(para_1.text) is int:
				new_planet.append(str_to_var(para_1.text)) # radius
			else:
				new_planet.append(60000)
				
			new_planet.append(true) # has_atmos
			new_planet.append(new_planet[2]*2) # atmos_radius
			
			if str_to_var(para_2.text) is float or str_to_var(para_2.text) is int:
				new_planet.append(str_to_var(para_2.text)) # gravity
			else:
				new_planet.append(1.0)
			
			new_planet.append(Vector3(0.5, 0.5, 0.5))
			
			gpsdata.planets.append(new_planet)
			var new_planet_idx = gpsdata.planets.size() - 1
			map.spawn_planet(new_planet_idx)
			map.update_object_buttons()
			print("added" + str(gpsdata.planets[new_planet_idx]))
			confirm_label.text = "Added Planet: " + str(gpsdata.planets[new_planet_idx][0])
		1:
			# [id, position, is_static, display_name, faction, type, colour]
			var new_station: Array = [000] # id
			new_station.append(gpsdata.convert_gps_to_vector3(gps)) # pos
			new_station.append(true) # is_static
			new_station.append(gpsdata.get_gps_name(gps)) # display_name
			if para_1.text != null:
				new_station.append(para_1.text)
			else:
				new_station.append("Unknown") # faction
			if para_2.text != null:
				new_station.append(para_2.text)
			else:
				new_station.append("Station") # type
			new_station.append(Vector3(1, 1, 1)) # colour
			
			gpsdata.stations.append(new_station)
			var new_station_idx = gpsdata.stations.size() - 1
			map.spawn_station(new_station_idx)
			map.update_object_buttons()
			print("added" + str(gpsdata.stations[new_station_idx]))
			confirm_label.text = "Added Grid: " + str(gpsdata.stations[new_station_idx][3])
		2:
			pass
			
	gps_insert.text = ""
	confirm_label.visible = true
