extends MultiplayerSpawner

const PLAYER_SCN = preload("res://Scenes/Player/player.tscn")

func _enter_tree() -> void:
	spawn_function = _spawn_player

func _spawn_player(data: Array):
	# Parse data
	var id : int = data[0]
	var info = null
	if len(data) > 1:
		info = data[1]
	
	print("Spawning player with ID %s" % id)
	var player = PLAYER_SCN.instantiate()
	player.name = str(id)
	
	player.set_multiplayer_authority(id, true)
	
	# Set up player info (username)
	if info != null:
		player.set_username(info["name"])
	return player

func despawn_all_players():
	for child in get_node(spawn_path).get_children():
		child.queue_free()

func despawn_player(id: int):
	if get_node(spawn_path).has_node(str(id)):
		get_node(spawn_path).get_node(str(id)).queue_free()
