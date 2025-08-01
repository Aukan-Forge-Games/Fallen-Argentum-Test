extends Node2D
class_name MoveActionPreview

@onready var line_2d: Line2D = $Line2D
@onready var end_point_sprite: Sprite2D = $EndPointSprite

func _ready():
	line_2d.position = Globals.tile_size / 2.0

func set_path_preview(path: Array[Vector2i]):
	if len(path) == 0:
		line_2d.hide()
		end_point_sprite.hide()
		return
	
	var points : Array[Vector2] = []
	for point in path:
		points.append(Vector2(point * Globals.tile_size))
	
	line_2d.points = points
	line_2d.show()
	
	end_point_sprite.position = points[len(points) - 1] + Globals.tile_size / 2.0
	end_point_sprite.show()
