extends Node2D
## Handles switching scenes in multiplayer
class_name GameWorldManager
@onready var spawner: MultiplayerSpawner = $WorldSpawner


@onready var world: Node2D = $World
enum Worlds {
	JOIN,
	LOBBY,
	GAME
}
func _ready():
	SceneTransition.world_manager = self
	change_scene(Worlds.JOIN)
	

func change_scene(scn_id: Worlds):
	spawner.spawn([scn_id])
	
