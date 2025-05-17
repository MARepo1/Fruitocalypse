extends Control

const PORT = 9999

@export var database_file_path = "res://auth/LoginDatabase.json"

var peer = ENetMultiplayerPeer.new()
var database = {}
var logged_users = {}
var connected_peer_ids = []

func _ready():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	load_database()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func load_database(path_to_database_file = database_file_path):
	var file = FileAccess.open(path_to_database_file, FileAccess.READ)
	var file_content = file.get_as_text()
	database = JSON.parse_string(file_content)


@rpc("any_peer", "call_remote")
func authenticate_player(user, password):
	var peer_id = multiplayer.get_remote_sender_id()
	
	if not user in database:
		rpc_id(peer_id, "authentication_failed", "User doesn't exist")
	elif not database[user]['password'] == password:
		rpc_id(peer_id, "authentication_failed", "Password doesn't match")
	elif user in logged_users:
		rpc_id(peer_id, "authentication_failed", "User is already logged")
	elif database[user]['password'] == password:
		var token = randi()
		logged_users[user] = token
		rpc_id(peer_id, "authentication_succeed", token)
		rpc("clear_logged_players")
		for logged_user in logged_users.keys():
			rpc("add_logged_player", database[logged_user]['name'])
	


@rpc("any_peer", "call_remote")
func start_game():
	rpc("start_game")
	get_tree().change_scene_to_file("res://world.tscn")
	#var peer_id = multiplayer.get_remote_sender_id()
	#rpc_id(peer_id, "add_player_request", peer_id)


@rpc
func authentication_failed(error_message):
	pass


@rpc
func authentication_succeed(session_token):
	pass


@rpc
func add_logged_player(player_name):
	pass


@rpc
func clear_logged_players():
	pass
	
@rpc
func send_credentials():
	pass

# Handle new connections
func _on_peer_connected(peer_id: int) -> void:
	print("Peer connected:", peer_id)

# Handle disconnections
func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer disconnected:", peer_id)
	if logged_users.has(peer_id):
		logged_users.erase(peer_id)

@rpc	
func add_player(id):
	pass

@rpc	
func add_newly_connected_player_character(new_peer_id):
	pass
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	pass
