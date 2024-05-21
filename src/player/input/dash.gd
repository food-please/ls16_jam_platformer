extends FSMState

@export var max_speed_x: = 196.0

var move_direction: = Vector2.ZERO

@onready var move_state: = get_parent() as PlayerMoveState
@onready var dash_timer: = $Timer as Timer


func _unhandled_input(event: InputEvent) -> void:
	if move_state.player.is_on_floor() and event.is_action_pressed("jump"):
		_fsm.swap("Move/Air", 
			{impulse = move_state.jump_impulse, velocity = move_state.player.velocity})


func _physics_process(delta: float) -> void:
	if not is_equal_approx(PlayerMoveState.get_move_direction().x - move_direction.x, 0.0):
		_fsm.swap("Move/Run")
		return
	
	if not move_state.player.is_on_floor():
		_fsm.swap("Move/Air", {})
	move_state.physics_process(delta)


# Initialize the state. E.g. change the animation.
func enter(data: = {}) -> void:
	move_state.enter(data)
	
	move_direction = Vector2.RIGHT
	if move_state.player.gfx.facing == CharacterGFX.Facing.LEFT:
		move_direction = Vector2.LEFT
	
	move_state.max_speed.x = max_speed_x
	move_state.player.velocity += _calculate_dash_velocity()
	move_state.player.gfx.play("air_jump")
	
	if not dash_timer.timeout.is_connected(_on_dash_timer_timeout):
		dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_timer.start()


# Clean up the state. E.g. reinitialize values like a timer.
func exit() -> void:
	if dash_timer.timeout.is_connected(_on_dash_timer_timeout):
		dash_timer.timeout.disconnect(_on_dash_timer_timeout)
	
	dash_timer.stop()
	
	move_state.max_speed = move_state.max_speed_default
	move_state.exit()


func _calculate_dash_velocity() -> Vector2:
	return PlayerMoveState.calculate_velocity(
		move_state.player.velocity,
		move_state.max_speed,
		Vector2(100000.0, 0.0),
		1.0,
		move_direction
	)


func _on_dash_timer_timeout() -> void:
	if move_state.player.is_on_floor():
		if is_equal_approx(PlayerMoveState.get_move_direction().x, 0.0):
			_fsm.swap("Move/Idle")
		else:
			_fsm.swap("Move/Run")
