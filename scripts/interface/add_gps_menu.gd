extends Control

@onready var type_select: OptionButton = get_node("type_select")
@onready var submit_button: Button = get_node("submit_button")

func _process(delta):
	if type_select.selected != -1:
		submit_button.disabled = false
	else:
		submit_button.disabled = true
		submit_button.text = "Select type to add GPS"
		
	match type_select.selected:
		0:
			submit_button.text = "Add GPS as Planet"
		1:
			submit_button.text = "Add GPS as Grid"
		2:
			submit_button.text = "Add GPS as Asteroid"
	


func _on_submit_button_pressed():
	match type_select.selected:
		0:
			pass
		1:
			# [id, position, is_static, display_name, faction, type, colour]
			var new_station: Array = []
		2:
			pass
