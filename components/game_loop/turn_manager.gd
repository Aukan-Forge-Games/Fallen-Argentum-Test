extends Node
class_name TurnManager

@onready var player_actions: Node = $PlayerActions

var actions : Array[Action] = []

const MAJOR_ACTIONS: int = 1
const MINOR_ACTIONS: int = 2
var major_actions_remaining : int = MAJOR_ACTIONS:
	set=set_major_actions_remaining
signal major_actions_changed(to: int)
var minor_actions_remaining : int = MINOR_ACTIONS:
	set=set_minor_actions_remaining
signal minor_actions_changed(to: int)

var active_action : Action = null ## Used to track the action the player currently has selected.

@export var game_board : GameBoard
@export var local_player_pawn: Pawn # TODO: instantiate players as they join

func _ready():
	#TODO: load actions from a player character / profile
	
	#TODO: player setup
	for action in player_actions.get_children():
		if action is Action:
			actions.append(action)
			action.game_board = game_board
			# TODO: the following is temporary
			action.my_pawn = local_player_pawn
			local_player_pawn.board_pos = game_board.local_to_map(local_player_pawn.position)

func start_turn():
	reset_actions_remaining()

func reset_actions_remaining():
	major_actions_remaining = MAJOR_ACTIONS
	minor_actions_remaining = MINOR_ACTIONS

func set_major_actions_remaining(to: int):
	major_actions_remaining = to
	major_actions_changed.emit(major_actions_remaining)

func set_minor_actions_remaining(to: int):
	minor_actions_remaining = to
	minor_actions_changed.emit(minor_actions_remaining)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		select_action(actions[0])

func select_action(action: Action):
	action.on_selected()
	
