extends Node2D
## Class for game pieces, such as the Player and enemies.
## Contains functions for moving between squares on the board.
class_name Pawn

@export var board_pos : Vector2i = Vector2i.ZERO:
	set=set_board_pos

# Use these to control animations
signal move_started()
signal move_ended()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var move_tween : Tween

## Player username OR enemy name
var display_name : String = ""

# Each pawn holds the actions it can perform
@onready var actions_node: Node = $Actions
var actions : Array[Action] = []
var game_board : GameBoard = null

signal pawn_used_action(action: Action)

func _ready():
	animation_player.play("idle")
	# Move to board pos (set by spawner)
	position = Vector2(board_pos * Globals.tile_size) + Globals.tile_size / 2.0
	
	for child in actions_node.get_children():
		set_up_action(child)
		actions.append(child)

func set_up_action(action : Action):
	action.my_pawn = self
	action.game_board = game_board
	action.action_used.connect(pawn_used_action.emit.bind(action)) # Propagate action used signal

func get_actions() -> Array[Action]:
	return actions

@rpc("authority", "call_local", "reliable")
func move_on_path(path: Array[Vector2i]):
	if len(path) == 0:
		printerr("Can't move along empty path")
		return
	move_started.emit()
	# Create path follow
	if move_tween:
		move_tween.kill()
	move_tween = create_tween()
	for point in path:
		move_tween.tween_property(self, 'position', Vector2(point * Globals.tile_size) + Globals.tile_size / 2.0, 0.1)
	animation_player.play("walk")
	await move_tween.finished
	
	move_ended.emit()
	animation_player.play("idle")
	board_pos = path[len(path) - 1]

## Returns the number of moves needed to reach a given point
func get_path_distance_to(pos: Vector2i) -> int:
	return false

func get_board_pos() -> Vector2i:
	return board_pos

func set_board_pos(pos: Vector2i):
	board_pos = pos

func set_display_name(string: String):
	display_name = string
