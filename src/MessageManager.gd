extends Node

var messages: Dictionary = {
	0: 'help me',
	1: 'there is a monster outside',
	2: 'it just woke up',
	3: 'hiding in a closet'
}

var responses: Dictionary = {
	0: ['to call security, type "help me" then press enter', 0],
	1: ['what is your situation?', 1],
	2: ['is the monster asleep?', 2],
	3: ['where are you?', 3]
}

var _curr_index: int = 0

func _ready():
	send_response(0)
	
func _on_message_sent(message_index: int):
	_curr_index += 1
	var res = responses.get(_curr_index)
	await get_tree().create_timer(res[1])

func send_response(index: int):
	var res = responses.get(index)
	EventBus.response_sent.emit(res[0], index)
