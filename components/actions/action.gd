extends Node
## Defines basic functionality for a player or enemy action
class_name Action

enum States {
	IDLE, ## The action is not being used
	PREVIEW, ## Player is previewing the action
	EXECUTE ## Currently doing the action
}

var state : States = States.IDLE
@export var game_board : GameBoard
var my_pawn : Pawn ## The player or enemy pawn that can perform this action

var string_name : String = "ActionName"

enum ActionTypes {
	MAJOR,
	MINOR
}

var action_type : ActionTypes = ActionTypes.MAJOR

signal action_used()

func on_selected():
	start_preview() ## Default behavior, can be overridden.

func _ready():
	pass

func _process(_dt):
	match state:
		States.IDLE:
			pass
		States.PREVIEW:
			_preview(_dt)
		States.EXECUTE:
			_execute(_dt)

## Usually, this will activate this action.
func _on_board_pos_selected(pos: Vector2i):
	pass

## User has decided not to use this action
func cancel_action():
	state = States.IDLE

#region preview_state
func start_preview():
	state = States.PREVIEW
	pass

func _preview(dt):
	pass

func _enter_preview():
	pass

func _exit_preview():
	pass
#endregion

#region execute_state
func _execute(dt):
	pass

func _enter_execute():
	state = States.EXECUTE
	pass

func _exit_execute():
	pass
#endregion
