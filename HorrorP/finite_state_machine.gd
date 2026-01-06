
class_name FiniteStateMachine
extends Node

@export var state: CharacterState


func _ready():
	transition(state)

func transition(new_state: CharacterState):
	if state is CharacterState:
		state._exit_state()
	new_state._enter_state()
	state = new_state
		
	
