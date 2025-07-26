extends MultiplayerSynchronizer

@export var move_input : Vector2
signal attacked()

func _ready():
	set_physics_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _physics_process(_dt: float) -> void:
	move_input = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("attack1"):
		attack.rpc()
	if Input.is_action_just_pressed("action"):
		action.rpc_id(1, [get_multiplayer_authority()])

## Placeholder action function. Causes player to 'pop'.
@rpc("authority", "call_local", "reliable")
func attack():
	attacked.emit()

@rpc("authority", "call_remote", "reliable")
func action(data: Array):
	var player_id : int = data[0]
	print("Player %s performed action!" % player_id)
