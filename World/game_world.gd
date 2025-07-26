extends Node
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var players: Node2D = $Players

const PLAYER_SCN = preload("res://Scenes/Player/player.tscn")

func _ready():
	
	if not multiplayer.is_server():
		# Spawn myself, a peer.
		_spawn_player(multiplayer.get_unique_id())
		for id in multiplayer.get_peers():
			_spawn_player(id)
		return
	
	# Spawn myself (the server). No players can be connected yet.
	_spawn_player(1)
	
	Lobby.player_loaded.rpc_id(1)
	player_spawner.spawn_path = get_path_to(players)
	
	# Spawning and deleting players
	multiplayer.peer_connected.connect(_spawn_player)
	multiplayer.peer_disconnected.connect(_free_player)
	
	

func _exit_tree():
	Lobby.leave_game()
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(_spawn_player)
	multiplayer.peer_disconnected.disconnect(_free_player)

func _spawn_player(id: int):
	var player = PLAYER_SCN.instantiate()
	player.name = str(id)
	
	players.add_child(player, true)
	player.set_multiplayer_authority(id, true)

func _free_player(id: int):
	if not players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()
