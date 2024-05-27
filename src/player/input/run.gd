extends FSMState

@onready var move_state: = get_parent() as PlayerMoveState


func _ready() -> void:
	super._ready()
	await move_state.ready
	move_state.player.hurt.connect(_on_hurt)


func _unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	
	if event.is_action_pressed("dash") and Constants.can_player_dash:
		_fsm.swap("Move/Dash")


func _physics_process(delta: float) -> void:
	if move_state.player.is_on_floor():
		if is_equal_approx(PlayerMoveState.get_move_direction().x, 0.0):
			_fsm.swap("Move/Idle")
	
	else:
		_fsm.swap("Move/Air")
	move_state.physics_process(delta)


# Initialize the state. E.g. change the animation.
func enter(data: = {}) -> void:
	move_state.enter(data)
	
	move_state.player.gfx.play("run")


# Clean up the state. E.g. reinitialize values like a timer.
func exit() -> void:
	move_state.exit()


func _on_hurt() -> void:
	_fsm.swap("Hurt")
