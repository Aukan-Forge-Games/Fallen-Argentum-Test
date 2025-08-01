extends Area2D

@onready var players_ready_label: Label = $PlayersReadyLabel

var players_touching : Array[Player] = []

@export var players_ready: Dictionary[int, bool] = {}:
	set=_set_players_ready

func _ready():
	_check_players_ready()
	Lobby.player_connected.connect(func(_id, _info): _check_players_ready())
	Lobby.player_disconnected.connect(func(_id): _check_players_ready())

func _on_body_entered(body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	if body is Player:
		players_touching.append(body)
	
	_check_players_ready()


func _on_body_exited(body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	if body in players_touching:
		players_touching.erase(body)
	
	_check_players_ready()

## Server only function
func _check_players_ready():
	if not multiplayer.is_server():
		return
	
	var ready : Dictionary[int, bool] = {}
	for id in Lobby.get_player_ids():
		ready[id] = false
	
	for player in players_touching:
		ready[player.get_multiplayer_authority()] = true
	
	_set_players_ready(ready)
	
	# If everyone is ready, start the game
	if not false in ready.values() and len(ready.values()) > 0:
		start_game.rpc()

func _set_players_ready(ready: Dictionary[int, bool]):
	players_ready = ready
	var player_count : int = len(ready.keys())
	var ready_player_count : int = 0
	for id in ready.keys():
		if ready[id]:
			ready_player_count += 1
	
	players_ready_label.text = "%s/%s Players Ready" % [ready_player_count, player_count]

@rpc("authority", "call_local", "reliable")
func start_game():
	# Bring everyone into the grid level.
	SceneTransition.change_scene_to(load("res://world/game_world.tscn"))
	print("Lego")
