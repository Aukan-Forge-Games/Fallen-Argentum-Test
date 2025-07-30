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

enum ActionTypes {
	MAJOR,
	MINOR,
	MOVE
}

var action_type : ActionTypes = ActionTypes.MAJOR

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

#region preview_state
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
	pass

func _exit_execute():
	pass
#endregion
