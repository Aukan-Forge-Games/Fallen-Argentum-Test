extends Node

@onready var players: Node2D = $Players

const PLAYER_SCN = preload("res://Scenes/Player/player.tscn")

func _ready():
	# Spawning and deleting players
	Lobby.player_connected.connect(_spawn_player)
	Lobby.player_disconnected.connect(_free_player)
	
	if not multiplayer.is_server():
		# Spawn myself, a peer
		_spawn_player(multiplayer.get_unique_id())
		return
	
	# Spawn myself (the server)
	_spawn_player(1)

func _exit_tree():
	if multiplayer.multiplayer_peer != null and not multiplayer.is_server():
		return
	Lobby.player_connected.disconnect(_spawn_player)
	Lobby.player_disconnected.disconnect(_free_player)

func _spawn_player(id: int, info: Variant = null):
	print("Spawning player with ID %s" % id)
	var player = PLAYER_SCN.instantiate()
	player.name = str(id)
	
	player.set_multiplayer_authority(id, true)
	players.add_child(player, true)
	
	# Set up player info (username)
	if info != null:
		player.set_username(info["name"])
	else:
		# This is the local player -- don't show a username.
		player.set_username("")
	

func _free_player(id: int):
	if not players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()
