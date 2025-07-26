extends CanvasLayer

@onready var black_rectangle: ColorRect = $BlackRectangle
@onready var message_label: RichTextLabel = $BlackRectangle/MessageLabel

signal fade_in_finished()
signal fade_out_finished()

var fade_tween : Tween

func _ready():
	black_rectangle.modulate = Color(1,1,1,0)
	message_label.text = ""
	black_rectangle.hide()

func change_scene_to(scn: PackedScene):
	_fade_in()
	await fade_in_finished
	finish_change_scene(scn)

## Fade to black and await "finish_change_scene" to fade back in.
func fade_to_black_with_message(msg: String):
	set_message(msg)
	_fade_in()

func finish_change_scene(scn: PackedScene):
	get_tree().change_scene_to_packed(scn)
	_fade_out()

func set_message(msg: String):
	message_label.text = msg

func _fade_in():
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	# Show black color rect to block mouse
	black_rectangle.show()
	fade_tween.tween_property(black_rectangle, "modulate", Color(1,1,1,1), 0.5).from(Color(1,1,1,0))
	fade_tween.finished.connect(fade_in_finished.emit, CONNECT_ONE_SHOT)

func _fade_out():
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(black_rectangle, "modulate", Color(1,1,1,0), 1.0).from(Color(1,1,1,1))
	fade_tween.finished.connect(fade_out_finished.emit, CONNECT_ONE_SHOT)
	# When fade out finishes, hide black rectangle to stop blocking mouse inputs.
	fade_tween.finished.connect(black_rectangle.hide, CONNECT_ONE_SHOT)
