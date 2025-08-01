extends Node
class_name TurnManager
## Manages a player's turn, as well as switching between player turns and enemy turns

## Turn order starts with the server, then other players, then enemies.
enum TurnPhase {
	PLAYERS,
	ENEMIES
}
var turn_phase : TurnPhase = TurnPhase.PLAYERS

var turn_order : Array = [
	# player ids
]
var current_turn_idx : int = 0

const MAJOR_ACTIONS: int = 1
const MINOR_ACTIONS: int = 2
var major_actions_remaining : int = MAJOR_ACTIONS:
	set=set_major_actions_remaining
signal major_actions_changed(to: int)
var minor_actions_remaining : int = MINOR_ACTIONS:
	set=set_minor_actions_remaining
signal minor_actions_changed(to: int)

@export var game_board : GameBoard
@onready var action_interface: CanvasLayer = $ActionInterfaceCanvasLayer


func _ready():
	#TODO: load actions from a player character / profile
	
	#TODO: player setup

	
	if not multiplayer.is_server():
		return



func update_turn_order(): ## TODO: call this when a new player joins
	turn_order.clear()
	for id in Lobby.get_player_ids():
		turn_order.append(id)
	
	start_turn.rpc_id(turn_order[current_turn_idx])

@rpc("authority", "call_local", "reliable")
func start_turn():
	reset_actions_remaining()
	action_interface.load_actions(PlayerPawnSpawner.get_player_pawn(multiplayer.get_unique_id()).get_actions())
	action_interface.start_my_turn()

# End my turn and go to the next player's turn
func end_turn():
	action_interface.end_my_turn()
	server_next_turn.rpc_id(1)

# Called by a peer when their turn ends. Gives turn to the next player
@rpc("any_peer", "call_local", "reliable")
func server_next_turn():
	current_turn_idx = (current_turn_idx + 1) % len(turn_order)
	start_turn.rpc_id(turn_order[current_turn_idx])

func reset_actions_remaining():
	major_actions_remaining = MAJOR_ACTIONS
	minor_actions_remaining = MINOR_ACTIONS

func set_major_actions_remaining(to: int):
	major_actions_remaining = to
	major_actions_changed.emit(major_actions_remaining)

func set_minor_actions_remaining(to: int):
	minor_actions_remaining = to
	minor_actions_changed.emit(minor_actions_remaining)

func select_action(action: Action):
	action.on_selected()

func _on_action_used(action: Action):
	# Remove action count of correct type
	match action.action_type:
		Action.ActionTypes.MAJOR:
			set_major_actions_remaining(major_actions_remaining - 1)
		Action.ActionTypes.MINOR:
			set_minor_actions_remaining(minor_actions_remaining - 1)


func _on_action_interface_canvas_layer_end_turn() -> void:
	end_turn()
