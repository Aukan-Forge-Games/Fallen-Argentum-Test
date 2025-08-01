extends Resource
class_name ActionData

@export var action_script : Script

func instantiate() -> Action:
	var action = Action.new()
	action.set_script(action_script)
	return action
