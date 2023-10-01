extends PanelContainer

class_name CodeWindow

@export var textbox: RichTextLabel

func display_response(text: String):
	textbox.text = text
