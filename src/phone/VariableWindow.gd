extends PanelContainer

@export var label: RichTextLabel

var var_color: String = 'white'
var num_color: String = 'green'

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.variable_list_updated.connect(_on_variable_list_updated)
	_on_variable_list_updated({})
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_variable_list_updated(variable_list: Dictionary):
	if variable_list.is_empty():
		label.text = 'VARIABLE LIST EMPTY'
	else:
		label.text = ''
		for var_name in variable_list:
			label.text += '[color=%s]%s =[/color] [color=%s]%s[/color]\n' % [var_color, var_name, num_color, variable_list[var_name]]
