class_name StateMachine
extends Node

signal transitioned(state_name)

export var initial_state := NodePath()

onready var state: State = get_node(initial_state)

#grundklass för player state machine, tar in ett initial state
#gjord efter guide gdquest state machine

func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	state.enter()
	
func _unhandled_input(event: InputEvent):
	state.handle_input(event)
	
func _process(delta: float):
	state.update(delta)
	
func _physics_process(delta: float):
	state.physics_update(delta)
	
func transition_to(target_state_name : String, msg: Dictionary = {}):
	if not has_node(target_state_name):
		return
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	
