extends PanelContainer

@export var label: RichTextLabel

var text_color: String = 'white'
var link_color: String = 'green'
var comment_color: String = 'dim_gray'

var command_list: Dictionary = CommandList.copy()
var _access_granted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.command_renamed.connect(_on_command_renamed)
	EventBus.logged_in.connect(_on_login)
	_access_granted = false
	_build_help_screen_text()
	pass # Replace with function body.

func _on_login():
	_access_granted = true
	_build_help_screen_text()

func _build_help_screen_text():
	var text = 'Click on the [color=%s]%s[/color] commands for examples' % [link_color, link_color]
	text += '\n\n[color=%s][url=%s]%s <variable>[/url][/color] - Login using the code stored in <variable>' \
		% [link_color, 'login', command_list['login']]
	text += '\n\n[color=%s][url=%s]%s <old_name> <new_name>[/url][/color] - Rename a command from <old_name> to <new_name>' \
		% [link_color, 'rename', command_list['rename']]
	text += '\n\n[color=%s][url=%s]%s <variable> <"one"|"two"|...>[/url][/color] - Stores a single digit number into variable <variable>' \
		% [link_color, 'setdigit', command_list['setdigit']]
	text += '\n\n[color=%s][url=%s]%s  <taget_variable> <variable_1> <variable_2>[/url][/color] - Concatenates <variable_1> and <variable_2> and stores it into variable <target_variable>' \
		% [link_color, 'combine', command_list['combine']]
		
	if _access_granted:
		text += '\n\n[color=orange]ADMIN COMMANDS[/color]'
		text += '\n\n[color=%s][url=%s]%s <variable> <letter>[/url][/color] - Stores a letter into variable <variable>' \
			% [link_color, 'setletter', command_list['setletter']]
		text += '\n\n[color=%s][url=%s]%s <variable>[/url][/color] - Calls the number stored in variable <variable>' \
			% [link_color, 'callnumber', command_list['callnumber']]
		text += '\n\n[color=%s][url=%s]%s <"on"|"off">[/url][/color] - Turn the flashlight on/off' \
			% [link_color, 'flashlight', command_list['flashlight']]
	
	text = '[color=%s]%s[/color]' % [text_color, text]
	label.text = text
#	text += '\n\n[color=%s]%s <> <new_name>[/color] - Rename a command from <old_name> to <new_name>' % [link_color, command_list['setnumber']]
#	text += '\n\n[color=%s]%s <old_name> <new_name>[/color] - Rename a command from <old_name> to <new_name>' % [link_color, command_list['callnumber']]
#	text += '\n\n[color=%s]%s <old_name> <new_name>[/color] - Rename a command from <old_name> to <new_name>' % [link_color, command_list['combine']]

func _on_command_renamed(old_name: String, new_name: String):
	var key = command_list.find_key(old_name)
	if key != null:
		command_list[key] = new_name
		_build_help_screen_text()


func _on_meta_clicked(meta):
	if meta == 'go_back':
		_build_help_screen_text()
		return
		
	var text = ''
	if meta == 'login':
		text += '%s <variable>' % [command_list['login']]
		text += '\n\nExample:\n[color=%s]num = 555[/color]' % [comment_color]
		text += '\n> %s num' % [command_list['login']]
		text += '\n[color=%s]Attempts to login using the password 555[/color]' % [comment_color]
		
	elif meta == 'rename':
		text += '%s <old_name> <new_name>' % [command_list['rename']]
		text += '\n\nExample:\n> %s callnumber call' % [command_list['rename']]
		text += '\n[color=%s]"callnumber" command is now "call"[/color]' % [comment_color]
		
	elif meta == 'setdigit':
		text += '%s <variable> <"one"|"two"|...>' % [command_list['setdigit']]
		text += '\n\nExample:\n> %s x one' % [command_list['setdigit']]
		text += '\n[color=%s]x = 1[/color]' % [comment_color]
		text += '\n> %s var nine' % [command_list['setdigit']]
		text += '\n[color=%s]var = 9[/color]' % [comment_color]
		
	elif meta == 'combine':
		text += '%s <taget_variable> <variable_1> <variable_2>' % [command_list['combine']]
		text += '\n\nExample:\n[color=%s]x = 5, y = 18[/color]' % [comment_color]
		text += '\n> %s result x y' % [command_list['combine']]
		text += '\n[color=%s]result = 518[/color]' % [comment_color]
		
	elif meta == 'callnumber':
		text += '%s <variable>' % [command_list['callnumber']]
		text += '\n\nExample:\n[color=%s]num = 555[/color]' % [comment_color]
		text += '\n> %s num' % [command_list['callnumber']]
		text += '\n[color=%s]This calls the phone number at 555[/color]' % [comment_color]
		
	elif meta == 'setletter':
		text += '%s <variable> <letter>' % [command_list['setletter']]
		text += '\n\nExample:\n> %s x p' % [command_list['setletter']]
		text += '\n[color=%s]x = p[/color]' % [comment_color]
		text += '\n> %s var t' % [command_list['setletter']]
		text += '\n[color=%s]var = t[/color]' % [comment_color]
		
	elif meta == 'flashlight':
		text += '%s <"on"|"off">' % [command_list['flashlight']]
		text += '\n\nExample:\n> %s on' % [command_list['flashlight']]
		text += '\n[color=%s]This turns the flashlight on[/color]' % [comment_color]
	
	text += '\n\n[url=go_back][color=%s]Go back[/color][/url]' % [link_color]
	text = '[color=%s]%s[/color]' % [text_color, text]
	label.text = text
	pass # Replace with function body.
