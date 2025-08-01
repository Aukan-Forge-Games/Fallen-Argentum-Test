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

func _ready():
	#TODO: load actions from a player character / profile
	
	#TODO: player setup
	for action in player_actions.get_children():
		if action is Action:
			actions.append(action)
			action.game_board = game_board
			action.action_used.connect(_on_action_used.bind(action))


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

func _on_action_used(action: Action):
	# Remove action count of correct type
	match action.action_type:
		Action.ActionTypes.MAJOR:
			set_major_actions_remaining(major_actions_remaining - 1)
		Action.ActionTypes.MINOR:
			set_minor_actions_remaining(minor_actions_remaining - 1)


func _on_player_pawn_spawner_player_pawn_spawned(pawn: Pawn) -> void:
	# If this is my pawn, bind it to my action nodes.
	if pawn.get_multiplayer_authority() == multiplayer.get_unique_id():
		print("Binding my pawn...")
		for action in actions:
			action.my_pawn = pawn
