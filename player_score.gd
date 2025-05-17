extends Control

@onready var player_1_label = $P1Score
@onready var player_2_label = $P2Score
@onready var player_3_label = $P3Score
@onready var player_4_label = $P4Score

#var player_1_score = 0
#var player_2_score = 0
var remaining_time = 300
var goal = 10
var game_over = false  

@onready var player_winner_label = $WinnerLabel
@onready var label = $ScrollContainer/Label
@onready var line_edit = $LineEdit
@onready var container = $ScrollContainer


func _ready():
	# This connects the player_shooting global to the function "_on_player_shooting" which is located below in the script.
	SetPlayers.connect("set_fruit", Callable(self, "get_info"))
	$GameTimer.start()
	change_timer()
	if(multiplayer.get_peers().size() == 2):
		player_1_label.show()
		player_2_label.show()
	elif(multiplayer.get_peers().size() == 3):
		player_1_label.show()
		player_2_label.show()
		player_3_label.show()
	elif(multiplayer.get_peers().size() == 4):
		player_1_label.show()
		player_2_label.show()
		player_3_label.show()
		player_4_label.show()
		
func _input(event):
	if event.is_action_pressed("message"):
		$ChatControl.show()
	if event.is_action_pressed("release"):
		$ChatControl.hide()

func _process(delta):
	change_timer()

@rpc("any_peer", "call_local", "reliable", 2)
func add_score(shooter_name, score):
	if game_over:
		return 

	var peer_id = multiplayer.get_remote_sender_id()

	if shooter_name == "P1":
		player_1_label.text = "P1: " + str(score)
		$P1Value.text = str(score)
	elif shooter_name == "P2":
		player_2_label.text = "P2: " + str(score)
		$P2Value.text = str(score)
	elif shooter_name == "P3":
		player_3_label.text = "P3: " + str(score)
		$P3Value.text = str(score)
	elif shooter_name == "P4":
		player_4_label.text = "P4: " + str(score)
		$P4Value.text = str(score)
	
@rpc("any_peer", "call_local", "reliable", 2)
func get_winner():
	
	var player_1 = int($P1Value.text)
	var player_2 = int($P2Value.text)
	var player_3 = int($P3Value.text)
	var player_4 = int($P4Value.text)
	
	if (player_1 > player_2) && (player_1 > player_3) && (player_1 > player_4):
		rpc("declare_winner", "Player 1 Won!")  
	elif (player_2 > player_1) && (player_2 > player_3) && (player_2 > player_4):
		rpc("declare_winner", "Player 2 Won!")  
	elif (player_3 > player_1) && (player_3 > player_2) && (player_3 > player_4):
		rpc("declare_winner", "Player 3 Won!") 
	elif (player_4 > player_1) && (player_4 > player_2) && (player_4 > player_3):
		rpc("declare_winner", "Player 4 Won!")  
	elif (player_1 == player_2) && (player_2 == player_3) && (player_3 == player_4):
		rpc("declare_winner", "Draw")  
	


@rpc("any_peer", "call_local", "reliable", 2)
func declare_winner(winner_name):
	if game_over:
		return 
	
	game_over = true  
	player_winner_label.text = winner_name
	player_winner_label.show()
	$Restart.show()

	rpc("lock_game")


@rpc("any_peer", "call_local", "reliable", 2)
func lock_game():
	game_over = true  


func _on_restart_pressed() -> void:
	print("Restart Button Pressed")
	SetPlayers.restart.emit(multiplayer.get_unique_id())

func get_info(shooter_name, fruit_type):
	print(shooter_name)
	print(fruit_type)
	
	if game_over:
		return
		
	print("PLAYER SCORE SHOOTER NAME DISPLAY" + shooter_name)

	# Update the shooter's score based on their name
	if shooter_name == "P1":
		print("Player 1 Scored!")
		SetPlayers.player_1_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_1_score)
	elif shooter_name == "P2":
		print("Player 2 Scored!")
		SetPlayers.player_2_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_2_score)
	elif shooter_name == "P3":
		print("Player 3 Scored!")
		SetPlayers.player_3_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_3_score)
	elif shooter_name == "P4":
		print("Player 4 Scored!")
		SetPlayers.player_4_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_4_score)

func change_timer():
	var time_left = $GameTimer.time_left
	var minutes = floor(time_left/60)
	var seconds = int(time_left) % 60
	$TimerLabel.text = "%02d:%02d" % [minutes, seconds]


func _on_game_timer_timeout() -> void:
	rpc("get_winner")
