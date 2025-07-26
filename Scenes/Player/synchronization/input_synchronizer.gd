extends MultiplayerSynchronizer

@export var move_input : Vector2

#func _enter_tree():
	#set_physics_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _physics_process(_dt: float) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		move_input = Input.get_vector("left", "right", "up", "down")
