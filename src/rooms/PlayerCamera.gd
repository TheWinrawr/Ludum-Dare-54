extends Camera2D

class_name PlayerCamera

@onready var vp = get_viewport()
@onready var center: Vector2 = vp.get_visible_rect().size / 2

var max_drift: Vector2 = Vector2(50, 20)
var drag: float = 0.5

# shake camera stuff
var shake_duration = 1.0
var shake_time_left = 0.0
var magnitude = 8.0
var taper_off = true

var is_shaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_follow_mouse()
	_handle_shake(delta)
	
func _handle_shake(delta):
	if shake_time_left > 0:
		var m = magnitude * shake_time_left / shake_duration
		if !taper_off:
			m = magnitude
		offset.x = randf_range(-m, m)
		offset.y = randf_range(-m, m)
		
		shake_time_left -= delta
	elif is_shaking:
		offset = Vector2()
		is_shaking = false

func _follow_mouse():
	var mouse_pos = vp.get_mouse_position()
	var rect_size = vp.get_visible_rect().size
	var weights = Vector2.ZERO
	weights.x = clamp(mouse_pos.x  / (rect_size.x / 2) - 1, -1, 1)
	weights.y = clamp(mouse_pos.y  / (rect_size.y / 2) - 1, -1, 1)
	
	var new_camera_pos = center + max_drift * weights
	position = new_camera_pos

func shake(magnitude: float = 8.0, shake_duration: float = 1.0, taper_off: bool = true):
	if is_shaking && magnitude < self.magnitude:
		return
		
	self.magnitude = magnitude
	self.shake_duration = shake_duration
	self.taper_off = taper_off
	
	shake_time_left = shake_duration
	is_shaking = true
	
func fall_down(duration: float = 1.0):
	rotation_degrees = -20
	rotation_smoothing_speed = 5
	
	await get_tree().create_timer(duration).timeout
	rotation_degrees = 0
	rotation_smoothing_speed = 0.5
