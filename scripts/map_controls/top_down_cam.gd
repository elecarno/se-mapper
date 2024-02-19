extends Camera3D

var zoom_speed: float = 0.05
var min_zoom: float = 100
var max_zoom: float = 8000
var drag_sensitivity: float = 1000

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mov_speed = size * 0.25
		var rel = event.relative * mov_speed / zoom_speed / size
		position -= Vector3(rel.x, 0, rel.y)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			size -= zoom_speed * size
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			size += zoom_speed * size
		size = clamp(size, min_zoom, max_zoom)
