extends Node3D

func _ready():
	randomize()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SetPlayers.connect("restart", Callable(self, "on_restart"))


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func on_restart(peer_id):
	rpc("restart")

@rpc("any_peer", "call_local")
func restart():
	if multiplayer.is_server():
		get_tree().change_scene_to_file("res://auth/server.tscn")
	else:
		get_tree().change_scene_to_file("res://auth/client.tscn")

	
