extends Node

var planets: Array = [] # [name, position, radius, has_atmos, atmos_radius, gravity, colour]
var asteroids: Array = [] # [name, position]
var stations: Array = [] # [id, position, is_static, display_name, faction, type, colour]

func get_planet_center(corner_pos: Vector3, dimension: float) -> Vector3:
	var x = dimension + corner_pos.x
	var y = dimension + corner_pos.y
	var z = dimension + corner_pos.z
	var loc: Vector3 = Vector3(x/1000, y/1000, z/1000)
	return loc

func convert_gps_to_vector3(gps: String):
	var gps_split: Array = gps.split(":")
	var x: float = float(gps_split[2])
	var y: float = float(gps_split[3])
	var z: float = float(gps_split[4])
	var converted_gps: Vector3 = Vector3(x, y, z)
	return converted_gps

func get_gps_name(gps: String):
	var gps_split: Array = gps.split(":")
	var gpsname = gps_split[1]
	
	return gpsname

func check_is_gps(gps: String):
	var gps_split: Array = gps.split(":")
	if gps_split.size() < 4:
		return false
	else:
		return true
