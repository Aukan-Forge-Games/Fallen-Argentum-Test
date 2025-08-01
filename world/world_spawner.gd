extends MultiplayerSpawner

var current_world : Node = null

func _ready():
	spawn_function = _custom_spawn
	despawned.connect(_despawn_node)

func _custom_spawn(data: Array):
	var id = data[0]
	var scn = load(get_spawnable_scene(id))
	if scn == null:
		printerr("World Spawner has no scene id %s" % id)
	if current_world:
		current_world.queue_free()
	var inst = scn.instantiate()
	current_world = inst
	return inst
	
# only called on remote peers
func _despawn_node(node: Node):
	node.queue_free()
