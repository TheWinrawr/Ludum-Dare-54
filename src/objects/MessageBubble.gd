extends PanelContainer

@export var max_width: int = 150
@export var test_label: Label
@export var message: RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	set_text('the ')
	pass # Replace with function body.

func set_text(text: String):
	test_label.text = text
	test_label.visible = false
	message.text = text
	await get_tree().process_frame
	
	var width = min(max_width, test_label.size.x)
	self.set_size(Vector2(width, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
