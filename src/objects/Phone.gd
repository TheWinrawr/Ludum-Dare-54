extends PanelContainer

class_name Phone

@export var textbox: RichTextLabel
@export var response_box: Label

var _untyped_color: String = 'dark_gray'
var _typed_color: String = 'green'
var _text_messages: Array[String] = ['The quick brown fox jumped over the lazy dog', 'Hello world', 'jumped OVER the lazy dog']
var _message_index: int = 0
var _char_index: int = 0
var _curr_message: String = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	_next_message()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var complete_text = _curr_message.substr(0, _char_index)
	var incomplete_text = _curr_message.substr(_char_index, _curr_message.length() - _char_index)
	var text = "[color=%s]%s[/color][color=%s]%s[/color]" % [_typed_color, complete_text, _untyped_color, incomplete_text]
	textbox.text = text

func _unhandled_input(event):
	if event is InputEventKey:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if just_pressed:
			if event.keycode == KEY_ENTER:
				_send_message()
			else:
				_type_char(event.as_text())

func _send_message():
	EventBus.message_sent.emit(_message_index)
	_message_index
	_next_message()
	
func _next_message():
	if _message_index >= len(_text_messages):
		return
	_curr_message = _text_messages[_message_index]
	_char_index = 0
	
func _display_message(text: String):
	_curr_message = text
	_char_index = 0
	
func _type_char(letter: String):
	letter = letter.to_lower()
	if _char_index < _curr_message.length() and letter == _curr_message[_char_index].to_lower():
		_char_index = clamp(_char_index + 1, 0, _curr_message.length())
		if _char_index < _curr_message.length() and _curr_message[_char_index] == ' ':
			_char_index += 1
