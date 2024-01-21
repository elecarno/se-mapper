extends Control

func _on_open_save_pressed():
	get_node("file_dialog").popup()

func _on_file_dialog_file_selected(path):
	print(path)
	gpsdata.load_save(path)
	#OS.shell_open(path)
