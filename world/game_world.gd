extends Node2D

@onready var turn_manager: TurnManager = $TurnManager
var players_loaded : Array[int] = []

func _ready():
	# Instantiate players (on server)
	if not multiplayer.is_server():
		# Tell server that I have loaded in
		_on_player_loaded.rpc_id(1, multiplayer.get_unique_id())
		return
	
	# Despawn free-moving players
	PlayerSpawner.despawn_all_players()
	
	# Spawn myself (the server)
	PlayerPawnSpawner.spawn([1, Lobby.player_info])
	
	# Spawn a pawn for each player
	for id in Lobby.get_player_ids():
		if id != 1:
			PlayerPawnSpawner.spawn([id, Lobby.players[id]])
	
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	
	# I (server) have loaded in
	_on_player_loaded(multiplayer.get_unique_id())

@rpc("any_peer", "call_local", "reliable")
func _on_player_loaded(id: int):
	players_loaded.append(id)
	if len(players_loaded) == len(Lobby.get_player_ids()):
		turn_manager.update_turn_order()

func _on_player_connected(id: int, info: Variant = null):
	PlayerPawnSpawner.spawn([id, info])

func _on_player_disconnected(id: int):
	PlayerPawnSpawner.despawn_player(id)
