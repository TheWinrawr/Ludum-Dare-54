extends Node

var command_list: Dictionary = {
	'rename': 'rename',
	'setdigit': 'setdigit',
	'combine': 'combine',
	'login': 'login',
	'setletter': 'setletter',
	'callnumber': 'callnumber',
	'flashlight': 'flashlight'
}

func copy() -> Dictionary:
	return command_list.duplicate()
