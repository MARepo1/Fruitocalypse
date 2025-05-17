extends Control


@onready var label = $ScrollContainer/Label
@onready var line_edit = $LineEdit
@onready var container = $ScrollContainer




func _ready():
	line_edit.grab_focus()

@rpc("any_peer", "call_local", "reliable", 2)
func add_message(message):
	var peer_id = multiplayer.get_remote_sender_id()
	var message_text = "%d: %s" % [peer_id, message]
	label.text = label.text + "\n" + message_text
	container.scroll_vertical = label.size.y


func _on_line_edit_text_submitted(new_text):
	if new_text == "":
		return
	rpc("add_message", new_text)
	line_edit.clear()
	
