extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("send_command"):
		get_tree().change_scene_to_file("res://src/rooms/LockerFront.tscn")
