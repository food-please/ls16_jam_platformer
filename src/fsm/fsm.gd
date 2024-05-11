## Generic state machine.
class_name FSM extends Node

@export var initial_state: FSMState:
	set(value):
		initial_state = value


var _active_state: FSMState = null:
	set(value):
		if value == _active_state:
			return
		
		if _active_state:
			_active_state.exit()
			_active_state.break_connections()
			_set_process_state(_active_state, false)
		
		_active_state = value
		if _active_state:
			_active_state.make_connections()
			_set_process_state(_active_state, true)


func _ready() -> void:
	assert(initial_state, "FSM %s does not have an initial state set!" % name)


## (Re)start the FSM, setting the initial state as the active state.
func start() -> void:
	swap(get_path_to(initial_state))


## An inactive FSM has no processing state, does not receive signals, etc.
func stop() -> void:
	_active_state = null


## Swaps out the active state, 
func swap(state_path: String, data: = {}) -> void:
	if not has_node(state_path):
		printerr("%s::swap() error - state path '%s' is invalid." % [name, state_path])
		return
	
	var target_state: = get_node(state_path) as FSMState
	if target_state:
		_active_state = target_state
		_active_state.enter(data)
	
	else:
		printerr("%s::swap() error - object found at '%s' is not a FSMState." % [name, state_path])


func _set_process_state(state: FSMState, value: bool) -> void:
	state.set_process_input(value)
	state.set_process_unhandled_input(value)
	state.set_process(value)
	state.set_physics_process(value)
