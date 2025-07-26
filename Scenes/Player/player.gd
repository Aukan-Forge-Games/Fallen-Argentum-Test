extends CharacterBody2D
@export var ACCEL := 50.0
@export var MAX_SPD := 500.0
@export var FRICTION := 0.5

@onready var input_synchronizer: MultiplayerSynchronizer = $InputSynchronizer
var move : Vector2 = Vector2.ZERO

@onready var sprite_2d: Sprite2D = $Sprite2D

#func _enter_tree() -> void:
	#set_physics_process(multiplayer.is_server())

func _physics_process(dt: float) -> void:
	move = input_synchronizer.move_input
	
	# Make diagonal movement the same speed as cardinal directions but keep proportional control
	if move.length() > 1.0:
		move = move.normalized() 
	
	velocity += ACCEL * move  * dt
	
	var fric = -velocity * FRICTION
	velocity += fric * dt
	
	velocity = velocity.limit_length(MAX_SPD)
	
	move_and_slide()


func _on_input_synchronizer_action_1() -> void:
	create_tween().tween_property(sprite_2d, "scale", Vector2.ONE, 0.2).from(Vector2(1.5, 1.5)).set_trans(Tween.TRANS_BACK)
