extends PointLight2D

@onready var vp = get_viewport()
@onready var center = self.position

var max_drift = Vector2(50, 30)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_follow_mouse(delta)
	pass

func _follow_mouse(delta):
	var mouse_pos = vp.get_mouse_position()
	var rect_size = vp.get_visible_rect().size
	var weights = Vector2.ZERO
	weights.x = clamp(mouse_pos.x  / (rect_size.x / 2) - 1, -1, 1)
	weights.y = clamp(mouse_pos.y  / (rect_size.y / 2) - 1, -1, 1)
	
	var new_pos = center + max_drift * weights
	position = position.lerp(new_pos, 5 * delta)
