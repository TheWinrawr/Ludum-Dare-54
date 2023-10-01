extends Node

@export var code_window: CodeWindow
@export var flashlight: Node2D
@export var help_number: Node2D

var command_list: Dictionary = CommandList.copy()

var variable_list: Dictionary = {}

var _access_granted: bool = false
var _password = '1188'
var _call_number = 'h3lpm3'

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.command_sent.connect(_on_command_sent)
	EventBus.tablet_off.connect(_on_tablet_off)
	_access_granted = false
	flashlight.visible = false
	help_number.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_command_sent(command_text: String):
	command_text = command_text.strip_edges().to_lower()
	var args = command_text.split(' ', false)
	if len(args) == 0:
		return
	
	var command_name = args[0]
	var command = command_list.get(command_name)
	
	if command == null:
		code_window.display_response('ERR: unknown command "%s"' % command_name)
	
	elif command == 'login':
		if _check_args(args, 2):
			login_command(args[1])
	elif command == 'rename':
		if _check_args(args, 3):
			rename_command(args[1], args[2])
	elif command == 'setdigit':
		if _check_args(args, 3):
			setdigit_command(args[2], args[1])
	elif command == 'combine':
		if _check_args(args, 4):
			combine_command(args[2], args[3], args[1])
	elif command == 'callnumber' and _access_granted:
		if _check_args(args, 2):
			call_command(args[1])
	elif command == 'setletter' and _access_granted:
		if _check_args(args, 3):
			setletter_command(args[1], args[2])
	elif command == 'flashlight' and _access_granted:
		if _check_args(args, 2):
			flashlight_command(args[1])
	else:
		code_window.display_response('ERR: unknown command "%s"' % command_name)
			
func _check_args(args: Array, num_args: int) -> bool:
	if len(args) != num_args:
		code_window.display_response('ERR: incorrect number of arguments')
		return false
	return true
			
func call_command(variable_name: String):
	if not variable_list.has(variable_name):
		code_window.display_response('ERR: variable "%s" does not exist' % variable_name)
	elif variable_list[variable_name] != _call_number:
		code_window.display_response('ERR: number does not exist')
	else:
		code_window.display_response('Calling...')
		EventBus.number_called.emit()
	
func setletter_command(var_name: String, letter: String):
	if letter.length() != 1:
		code_window.display_response('ERR: "%s" is not a letter' % letter)
	else:
		variable_list[var_name] = letter
		code_window.display_response('variable %s set to %s' % [var_name, letter])
		EventBus.variable_list_updated.emit(variable_list)
		EventBus.command_resolved.emit('setletter')

func _on_tablet_off():
	flashlight_command('off')
	
func flashlight_command(arg: String):
	if arg == 'on':
		flashlight.visible = true
		help_number.visible = true
	elif arg == 'off':
		flashlight.visible = false
	else:
		code_window.display_response('ERR: unknown argument "%s"' % arg)
	
func login_command(variable_name: String):
	if not variable_list.has(variable_name):
		code_window.display_response('ERR: variable "%s" does not exist' % variable_name)
	elif variable_list[variable_name] != _password:
		code_window.display_response('ERR: incorrect password')
	else:
		_access_granted = true
		EventBus.logged_in.emit()
		code_window.display_response('Access granted, additional commands added')
		EventBus.command_resolved.emit('login')
	
func combine_command(var_1: String, var_2: String, target_var: String):
	if not variable_list.has(var_1):
		code_window.display_response('ERR: variable "%s" does not exist' % var_1)
	elif not variable_list.has(var_2):
		code_window.display_response('ERR: variable "%s" does not exist' % var_2)
	else:
		variable_list[target_var] = '%s%s' % [variable_list[var_1], variable_list[var_2]]
		code_window.display_response('variable %s set to %s' % [target_var, variable_list[target_var]])
		EventBus.variable_list_updated.emit(variable_list)
		EventBus.command_resolved.emit('combine')
			
func setdigit_command(num: String, var_name: String):
	var digits = {'zero': '0', 'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'}
	if not digits.has(num):
		code_window.display_response('ERR: unkonwn number "%s"' % num)
	else:
		variable_list[var_name] = digits[num]
		code_window.display_response('variable %s set to %s' % [var_name, digits[num]])
		EventBus.variable_list_updated.emit(variable_list)
		EventBus.command_resolved.emit('setdigit')
		
func rename_command(old_name: String, new_name: String):
	if command_list.get(new_name) != null:
		code_window.display_response('err: command "%s" already exists' % new_name)
	elif command_list.get(old_name) == null:
		code_window.display_response('err: command "%s" does not exist' % old_name)
	else:
		if !_access_granted and (old_name == 'callnumber' or old_name == 'setletter' or old_name == 'flashlight'):
			code_window.display_response('err: command "%s" does not exist' % old_name)
			return
			
		command_list[new_name] = command_list[old_name]
		command_list.erase(old_name)
		code_window.display_response('renamed command "%s" to "%s"' % [old_name, new_name])
		EventBus.command_renamed.emit(old_name, new_name)
		EventBus.command_resolved.emit('rename')
