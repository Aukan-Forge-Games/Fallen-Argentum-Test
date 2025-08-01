extends MultiplayerSpawner

var game_board : GameBoard
const PLAYER_PAWN_SCN = preload("res://scenes/player/player_pawn/player_pawn.tscn")

#TODO: load this from level data instead
@export var board_pos_spawn : Vector2i = Vector2i(10, 12)

signal player_pawn_spawned(pawn: Pawn)

func _enter_tree() -> void:
	spawn_function = _spawn_player_pawn

func _spawn_player_pawn(data: Array):
	# Parse data
	var id : int = data[0]
	var info = null
	if len(data) > 1:
		info = data[1]
	
	print("Spawning player with ID %s" % id)
	var player = PLAYER_PAWN_SCN.instantiate()
	player.set_board_pos(board_pos_spawn)
	player.name = str(id)
	player.game_board = game_board
	
	player.set_multiplayer_authority(id, true)
	
	player_pawn_spawned.emit(player)
	
	# Set up player info (username)
	if info != null:
		player.set_display_name(info["name"])
	return player

func get_player_pawn(id: int):
	if get_node(spawn_path).has_node(str(id)):
		return get_node(spawn_path).get_node(str(id))

func despawn_player(id: int):
	if get_node(spawn_path).has_node(str(id)):
		get_node(spawn_path).get_node(str(id)).queue_free()

func despawn_all_players():
	for child in get_node(spawn_path).get_children():
		child.queue_free()
