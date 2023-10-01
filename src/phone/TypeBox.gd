extends PanelContainer

@export var line_edit: LineEdit
@export var char_counter: Label

@onready var regex = RegEx.new()

var max_chars: int = 15

var _char_deleted: bool = false
var _prev_length: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	char_counter.add_theme_color_override('font_color', Color.WHITE)
	line_edit.max_length = max_chars
	regex.compile('[^a-zA-Z ]+')
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_char_counter()
	
	if Input.is_action_just_pressed("send_command"):
		EventBus.command_sent.emit(line_edit.text)
		line_edit.clear()
		
func _update_char_counter():
	var num_chars = line_edit.text.length()
	var counter = "%d/%d  " % [line_edit.text.length(), max_chars]
	char_counter.text = counter
	if num_chars >= max_chars:
		char_counter.add_theme_color_override('font_color', Color.RED)
	elif num_chars >= 10:
		char_counter.add_theme_color_override('font_color', Color.CORAL)
	else:
		char_counter.add_theme_color_override('font_color', Color.WHITE)


func _on_line_edit_text_changed(new_text):
	var result = regex.search(new_text)
	if result != null:
		_char_deleted = true
		line_edit.delete_char_at_caret()
	else:
		if !_char_deleted and _prev_length < new_text.length():
			EventBus.char_typed.emit()
			$TypingSFX.play()
		_char_deleted = false
		_prev_length = new_text.length()
