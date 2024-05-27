extends FSMState

@onready var move_state: = get_parent() as PlayerMoveState


func _ready() -> void:
	super._ready()
	await move_state.ready
	move_state.player.hurt.connect(_on_hurt)


func _unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)


func _physics_process(_delta: float) -> void:
	if move_state.player.is_on_floor():
		if PlayerMoveState.get_move_direction().x != 0.0:
			_fsm.swap("Move/Run")
	
	else:
		_fsm.swap("Move/Air")


# Initialize the state. E.g. change the animation.
func enter(data: = {}) -> void:
	move_state.enter(data)
	
	move_state.player.gfx.play("idle")
	
	move_state.max_speed = move_state.max_speed_default
	move_state.player.velocity = Vector2.ZERO
	
	print("Enter idle!")


# Clean up the state. E.g. reinitialize values like a timer.
func exit() -> void:
	move_state.exit()


func _on_hurt() -> void:
	_fsm.swap("Hurt")
