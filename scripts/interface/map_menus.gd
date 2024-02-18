extends Control

@onready var objects_menu = get_node("objects_menu")
@onready var objects_menu_open = get_node("objects_menu_open")
@onready var object_editor = get_node("object_editor")
@onready var add_gps_menu_open = get_node("add_gps_menu_open")
@onready var add_gps_menu = get_node("add_gps_menu")

func _on_close_button_pressed():
	objects_menu.visible = false
	object_editor.visible = false
	add_gps_menu.visible = false
	objects_menu_open.visible = true
	add_gps_menu_open.visible = true

func _on_objects_menu_open_pressed():
	objects_menu.visible = true
	objects_menu_open.visible = false
	add_gps_menu_open.visible = false

func _on_add_gps_menu_open_pressed():
	add_gps_menu_open.visible = false
	objects_menu_open.visible = false
	add_gps_menu.visible = true
