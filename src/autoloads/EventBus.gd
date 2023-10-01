extends Node

signal message_sent(message_id: int)
signal security_replied(response_text: String, messsage_text: String)

signal command_sent(command: String)
signal command_renamed(old_name: String, new_name: String)
signal command_resolved(command: String)
signal variable_list_updated(variable_list: Dictionary)
signal logged_in()
signal char_typed()

signal tablet_off()

signal monster_awake()

signal number_called()
