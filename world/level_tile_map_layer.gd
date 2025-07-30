extends TileMapLayer
class_name GameBoard

var astar = AStarGrid2D.new()

func _ready():
	# Load level here (TODO)
	
	# Configure astar
	var level_size : Vector2i = get_used_rect().size
	astar.region = Rect2(Vector2.ZERO, level_size)
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	# Set wall tiles as solid in the astar's grid
	for cell in get_used_cells():
		var data = get_cell_tile_data(cell)
		if data.has_custom_data("is_walkable"):
			astar.set_point_solid(cell, not data.get_custom_data("is_walkable"))

func get_path_cells(from_cell: Vector2i, to_cell: Vector2i) -> Array[Vector2i]:
	return astar.get_id_path(from_cell, to_cell, false)

func add_action_preview(preview: Node):
	add_child(preview)

func get_mouse_board_pos() -> Vector2i:
	return local_to_map(get_viewport().get_mouse_position())
