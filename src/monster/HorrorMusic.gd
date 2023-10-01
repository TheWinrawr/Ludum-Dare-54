extends AudioStreamPlayer

var target_db = -80

var db_rate = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_db(db: float, rate: float):
	target_db = db
	db_rate = rate
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = volume_db + (target_db - volume_db) * delta * db_rate
