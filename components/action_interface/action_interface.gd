extends CanvasLayer
@onready var my_turn_label: RichTextLabel = $MyTurnLabel
@onready var major_action_buttons_h_box: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/MajorActionButtonsHBox
@onready var minor_action_buttons_h_box: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer2/MinorActionButtonsHBox
@onready var end_turn_button: Button = $MarginContainer2/EndTurnButton

var action_buttons : Array[Button] = []

signal end_turn()
var is_my_turn : bool = false

@export var turn_manager: TurnManager

signal action_used(action: Action)

func _ready():
	turn_manager.major_actions_changed.connect(_on_major_actions_changed)
	turn_manager.minor_actions_changed.connect(_on_minor_actions_changed)
	end_my_turn()

# Create buttons based on actions
func load_actions(actions: Array[Action]):
	print("Loading actions %s" % actions)
	# Clear action buttons
	for child in major_action_buttons_h_box.get_children():
		child.queue_free()
	for child in minor_action_buttons_h_box.get_children():
		child.queue_free()
	action_buttons.clear()
	
	# Create new action buttons
	for action in actions:
		action.action_used.connect(action_used.emit.bind(action))
		var button = Button.new()
		button.text = action.string_name
		button.pressed.connect(action.start_preview)
		action_buttons.append(button)
		match action.action_type:
			Action.ActionTypes.MINOR:
				minor_action_buttons_h_box.add_child(button)
			Action.ActionTypes.MAJOR:
				major_action_buttons_h_box.add_child(button)

func _on_major_actions_changed(actions: int):
	if actions > 0:
		return
	for button in major_action_buttons_h_box.get_children():
		button.disabled = true

func _on_minor_actions_changed(actions: int):
	if actions > 0:
		return
	for button in minor_action_buttons_h_box.get_children():
		button.disabled = true

func start_my_turn():
	my_turn_label.show()
	is_my_turn = true
	for button in action_buttons:
		button.disabled = false
	end_turn_button.disabled = false

func end_my_turn():
	my_turn_label.hide()
	is_my_turn = false
	# Disable all action buttons, but keep them visible to make player experience better
	for button in action_buttons:
		button.disabled = true
	
	end_turn_button.disabled = true
	


func _on_end_turn_button_pressed() -> void:
	if is_my_turn:
		end_my_turn()
		end_turn.emit()
