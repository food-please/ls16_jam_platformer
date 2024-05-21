## A state interface to be used as part of a Finite State Machine.
class_name FSMState extends Node

# Keep track of all built-in connections to this state. The state will NOT receive signals unless
# it is the active state, so connections will be made/broken as the state is activated/deactivated.
var _connections: = []

@onready var _fsm: = _get_fsm(self)


func _ready() -> void:
	assert(_fsm, "FSMState %s is not a descendant of a FSM node!" % name)
	
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process(false)
	set_physics_process(false)
	break_connections()



func _unhandled_input(_event: InputEvent) -> void:
	return


func _physics_process(_delta: float) -> void:
	return


# Initialize the state. E.g. change the animation.
func enter(_data: = {}) -> void:
	return


# Clean up the state. E.g. reinitialize values like a timer.
func exit() -> void:
	return


## Reconnect this object to all signals stored in the _connections container.
## This should not be called manually, but is used by the [FSM].
func make_connections() -> void:
	if not _connections.size():
		return
	
	for cxn_data in _connections:
		var err: int = cxn_data.signal.connect(cxn_data.callable, cxn_data.flags)
		if err != OK:
			printerr("Error %d connecting signal in %s." % [err, name])
	_connections.clear()


## Remove all signals currently connected to this object, storing them in _connections container.
## This should not be called manually, but is used by the [FSM].
func break_connections() -> void:
	if _connections.size():
		return
	
	for cxn in get_incoming_connections():
		var saved_data: = {
			"signal": cxn.signal,
			"callable": cxn.callable,
			"flags": cxn.flags
		}
		_connections.append(saved_data)
		cxn.signal.disconnect(cxn.callable)


func _get_fsm(node: Node) -> FSM:
	if not node is FSM:
		return _get_fsm(node.get_parent())
	return node
