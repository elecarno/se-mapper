extends Control

@onready var objects_menu = get_node("objects_menu")
@onready var objects_menu_open = get_node("objects_menu_open")

func _on_close_button_pressed():
	objects_menu.visible = false
	objects_menu_open.visible = true

func _on_objects_menu_open_pressed():
	objects_menu.visible = true
	objects_menu_open.visible = false
