extends FSMState

@export var acceleration_x: = 100.0

@onready var move_state: = get_parent() as PlayerMoveState


func _ready() -> void:
	super._ready()
	await move_state.ready
	move_state.player.hurt.connect(_on_hurt)


func _unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)


func _physics_process(delta: float) -> void:
	move_state.physics_process(delta)
	
	if move_state.player.velocity.y < 0.0:
		move_state.player.gfx.play("air_jump") 
	
	else:
		move_state.player.gfx.play("air_fall")
	
	if move_state.player.is_on_floor():
		if is_equal_approx(PlayerMoveState.get_move_direction().x, 0.0):
			_fsm.swap("Move/Idle")
		else:
			_fsm.swap("Move/Run")
	
	elif move_state.player.is_on_wall():
		var wall_normal: = move_state.player.get_wall_normal().x
		var move_dir: = PlayerMoveState.get_move_direction().x
		if not is_equal_approx(move_dir, 0.0) and sign(move_dir) != sign(wall_normal):
			_fsm.swap("Move/Wall", { normal = wall_normal, velocity = move_state.player.velocity})


# Initialize the state. E.g. change the animation.
func enter(data: = {}) -> void:
	move_state.enter(data)
	
	if "velocity" in data:
		move_state.player.velocity = data.velocity
		move_state.max_speed.x = max(abs(data.velocity.x), move_state.max_speed_default.x)
	
	if "impulse" in data:
		# Player jumped.
		move_state.player.velocity += _calculate_jump_velocity(data.impulse)
	
	if "wall_jump" in data:
		move_state.max_speed.x \
			= max(move_state.max_speed_default.y, abs(move_state.player.velocity.x))
		move_state.acceleration.x = acceleration_x
		move_state.acceleration.y = move_state.acceleration_default.y

# Clean up the state. E.g. reinitialize values like a timer.
func exit() -> void:
	move_state.exit()
	move_state.acceleration = move_state.acceleration_default
	move_state.max_speed = move_state.max_speed_default


func _calculate_jump_velocity(impulse: = 0.0) -> Vector2:
	return PlayerMoveState.calculate_velocity(
		move_state.player.velocity,
		move_state.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)


func _jump() -> void:
	var impulse: = Vector2(move_state.player.scale.x, -1.0) * Vector2(160, 150)
	var data: = {
		velocity = impulse,
		wall_jump = true
	}
	_fsm.swap("Move/Air", data)


func _on_hurt() -> void:
	_fsm.swap("Hurt")
