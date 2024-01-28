extends Camera3D

@export var accel: float = 2500.0
@export var speed: float = 500.0
@export var mouse_speed: float = 300.0

var velocity = Vector3.ZERO
var look_angles = Vector2.ZERO

func _process(delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_angles.y = clamp(look_angles.y, PI / -2, PI / 2)
		set_rotation(Vector3(look_angles.y, look_angles.x, 0))
		var direction = update_dir()
		if direction.length_squared() > 0:
			velocity += direction * accel * delta
		if velocity.length() > speed:
			velocity = velocity.normalized() * speed
			
		translate(velocity * delta)
		
	if Input.is_action_pressed("sprint"):
		speed = 3000.0
		accel = 15000.0
	else:
		speed = 500.0
		accel = 2500.0
		
	if Input.is_action_pressed("zoom"):
		fov = 40
	else:
		fov = 75
	
func _input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			look_angles -= event.relative / mouse_speed
		
func update_dir():
	var dir = Vector3()
	if Input.is_action_pressed("forward"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("backwards"):
		dir += Vector3.BACK
	if Input.is_action_pressed("left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("right"):
		dir += Vector3.RIGHT
	if Input.is_action_pressed("up"):
		dir += Vector3.UP
	if Input.is_action_pressed("down"):
		dir += Vector3.DOWN
	if dir == Vector3.ZERO:
		velocity = Vector3.ZERO
		
	return dir.normalized()
