extends Node

@onready var players: Node2D = $Players
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner

func _ready():
	if not multiplayer.is_server():
		return
	
	# Spawn myself (the server)
	player_spawner.spawn([1, Lobby.player_info])
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)

func _on_player_connected(id: int, info: Variant = null):
	player_spawner.spawn([id, info])

func _on_player_disconnected(id: int):
	player_spawner.despawn_player(id)
