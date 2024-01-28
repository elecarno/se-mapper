extends Control

@onready var file_dialog: FileDialog = get_parent().get_node("file_dialog")
@onready var error_label: Label = get_node("error")
@onready var data_manager: data_manager = get_parent().get_node("data_manager")
var type: String = ""

func _on_open_gamesave_pressed():
	configure_file_dialog("Open Game Save (.sbs)")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.set_filters(["*.sbs"])
	file_dialog.popup()
	type = "gamesave_open"
	
func _on_open_mapdata_pressed():
	configure_file_dialog("Open Map Data (.json)")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.set_filters(["*.json"])
	file_dialog.popup()
	type = "mapdata_open"
	
func _on_save_mapdata_pressed():
		file_dialog.title = "Save Map Data"
		file_dialog.ok_button_text = "Save (.json)"
		file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		file_dialog.set_current_file("new map")
		file_dialog.set_filters(["*.json"])
		file_dialog.popup()
		type = "mapdata_save"

func _on_file_dialog_file_selected(path: String):
	print(path)
	match type:
		"gamesave_open":
			if path.contains(".sbs"): data_manager.load_gamesave(path)
			else: display_load_error("file is not a .sbs")
		"mapdata_open":
			if path.contains(".json"): data_manager.load_mapdata(path) # replace with json loader
			else: display_load_error("file is not a .json")
		"mapdata_save":
			data_manager.save_mapdata(path)
				
func _on_file_dialog_dir_selected(dir):
	print(dir)
	match type:
		"mapdata_save":
			data_manager.save_mapdata(dir)

func configure_file_dialog(open_text: String):
	file_dialog.title = open_text
	file_dialog.ok_button_text = open_text

func display_load_error(error_msg: String):
	file_dialog.hide()
	error_label.text = error_msg
	error_label.visible = true
