extends MultiplayerSynchronizer

@export var move_input : Vector2
signal action1()
#func _enter_tree():
	#set_physics_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _physics_process(_dt: float) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		move_input = Input.get_vector("left", "right", "up", "down")
		
		if Input.is_action_just_pressed("attack1"):
			action.rpc()

## Placeholder action function. Causes player to 'pop'.
@rpc("call_local", "authority", "reliable")
func action():
	action1.emit()
