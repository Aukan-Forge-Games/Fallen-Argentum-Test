extends Node2D
## Class for game pieces, such as the Player and enemies.
## Contains functions for moving between squares on the board.
class_name Pawn

var board_pos : Vector2i = Vector2i.ZERO

# Use these to control animations
signal move_started()
signal move_ended()

@rpc("authority", "call_local", "reliable")
func move_to_square(pos: Vector2i):
	move_started.emit()
	# Create path follow
	
	# TODO: Connect follow finished to this
	move_ended.emit()

## Returns the number of moves needed to reach a given point
func get_path_distance_to(pos: Vector2i) -> int:
	return false

func get_board_pos() -> Vector2i:
	return board_pos
