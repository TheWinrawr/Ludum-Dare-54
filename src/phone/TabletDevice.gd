extends Control

class_name Tablet

@onready var screen: Control = $Screen

var is_on: bool = false :
	get:
		return is_on

var _off_position: Vector2 = Vector2(125, 275)
var _on_position: Vector2 = Vector2(125, 125)
var _target_position: Vector2
var _mouse_inside: bool = false

var _position_offset: Vector2 = Vector2.ZERO
var _rotation_offset: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	switch_power(false)
	position = _off_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	if Input.is_action_just_pressed("mouse_click"):
		if _mouse_inside and !is_on:
			switch_power(true)
		elif !_mouse_inside and is_on:
			switch_power(false)
			
	if _mouse_inside:
		if is_on:
			_target_position = _on_position
		else:
			_target_position = _off_position - Vector2(0, 25)

	elif not _mouse_inside:
		if is_on:
			_target_position = _on_position + Vector2(0, 25)
		else:
			_target_position = _off_position

	position = position.lerp(_target_position + _position_offset, 5 * delta)
	rotation_degrees = rotation_degrees + (_rotation_offset - rotation_degrees) * delta * 3
	
func switch_power(power_on: bool):
	screen.visible = power_on
	is_on = power_on
	
	if !power_on:
		EventBus.tablet_off.emit()
		$NoiseSFX.stop()
	else:
		$NoiseSFX.play()
	
func drop_tablet_effect(duration: float):
	_position_offset.x = randf_range(-80, 80)
	_position_offset.y = randf_range(50, 70)
	_rotation_offset = randf_range(-30, 30)
	await get_tree().create_timer(duration).timeout
	_position_offset = Vector2.ZERO
	_rotation_offset = 0

func _on_mouse_entered():
	_mouse_inside = true

func _on_mouse_exited():
	_mouse_inside = false
