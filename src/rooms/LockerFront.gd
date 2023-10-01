extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	get_tree().change_scene_to_file("res://src/rooms/GameOver.tscn")

func win_screen():
	get_tree().change_scene_to_file("res://src/rooms/WinScreen.tscn")
