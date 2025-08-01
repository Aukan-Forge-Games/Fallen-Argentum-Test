extends Action
class_name MoveAction

const MOVE_PREVIEW_SCN = preload("res://scenes/actions/move_action_preview/move_action_preview.tscn")

var move_preview: MoveActionPreview
var mouse_grid_pos: Vector2i = Vector2i.ZERO

func _ready():
	action_type = ActionTypes.MOVE
	super._ready()


func _preview(dt):
	super._preview(dt)
	if not move_preview:
		move_preview = MOVE_PREVIEW_SCN.instantiate()
		game_board.add_action_preview(move_preview)
	
	mouse_grid_pos = game_board.get_mouse_board_pos()
	
	# Show preview from my pawn to mouse position
	move_preview.set_path_preview(game_board.get_path_cells(my_pawn.get_board_pos(), mouse_grid_pos))
	
	if Input.is_action_just_pressed("mb_primary"):
		_on_board_pos_selected(game_board.get_mouse_board_pos())

func _on_board_pos_selected(pos: Vector2i):
	# If this is a valid location, move
	var path = game_board.get_path_cells(my_pawn.get_board_pos(), pos)
	if path == null:
		return
	
	my_pawn.move_on_path.rpc(path)
	my_pawn.move_ended.connect(_on_move_completed, CONNECT_ONE_SHOT)
	action_used.emit()
	_enter_execute()

func _on_move_completed():
	# Remove path preview
	if move_preview:
		move_preview.queue_free()
		move_preview = null
	
	# Re-enter idle state
	state = States.IDLE
