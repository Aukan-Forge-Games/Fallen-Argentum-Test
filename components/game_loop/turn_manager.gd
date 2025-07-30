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

func _ready():
	#TODO: load actions from a player character / profile
	for action in player_actions.get_children():
		if action is Action:
			actions.append(action)

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
