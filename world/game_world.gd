extends Node2D

@onready var player_pawn_spawner: MultiplayerSpawner = $PlayerPawnSpawner

func _ready():
	# Instantiate players (on server)
	if not multiplayer.is_server():
		return
	
	# Spawn myself (the server)
	player_pawn_spawner.spawn([1, Lobby.player_info])
	
	# Spawn a pawn for each player
	for id in Lobby.get_player_ids():
		if id != 1:
			player_pawn_spawner.spawn([id, Lobby.players[id]])
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	
func _on_player_connected(id: int, info: Variant = null):
	player_pawn_spawner.spawn([id, info])

func _on_player_disconnected(id: int):
	player_pawn_spawner.despawn_player(id)
