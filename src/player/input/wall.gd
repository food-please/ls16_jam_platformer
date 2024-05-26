extends FSMState

@export var slide_acceleration: = 800.0
@export var max_slide_speed: = 52.0 
@export_range(0.0, 1.0) var friction_factor: = 0.15

@export var jump_strength: = Vector2(66.0, 53.0)

var _wall_normal: = -1.0
var _velocity: = Vector2.ZERO

@onready var move_state: = get_parent() as PlayerMoveState


func _unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	#if event.is_action_pressed("jump"):
		#if move_state.player.can_wall_jump():
			#_jump()


func _physics_process(delta: float) -> void:
	var player: = move_state.player
	if player.velocity.y > max_slide_speed:
		player.velocity.y = lerp(player.velocity.y, max_slide_speed, friction_factor)
	else:
		player.velocity.y += slide_acceleration*delta
	
	#player.velocity.y = clamp(player.velocity.y, -max_slide_speed, max_slide_speed)
	if player.move_and_slide():
		pass # COllision
	
	if player.is_on_floor():
		print("Goto floor")
		_fsm.swap("Move/Idle")
	else:
		var move_dir: = PlayerMoveState.get_move_direction().x
		var is_moving_away_from_wall: bool \
			= sign(move_dir) == sign(_wall_normal) or is_equal_approx(move_dir, 0.0)
		if is_moving_away_from_wall or not player.is_on_wall():
			_fsm.swap("Move/Air", { velocity = player.velocity })
		#if not player.is_on_wall():
			#print ("Goto air")
			#_fsm.swap("Move/Air", { velocity = player.velocity })

# Initialize the state. E.g. change the animation.
func enter(data: = {}) -> void:
	move_state.enter(data)
	
	_wall_normal = data.normal
	_velocity.y = clamp(data.velocity.y, -max_slide_speed, max_slide_speed)
	
	print("Entering wall")
	move_state.player.gfx.play("wall_slide")


# Clean up the state. E.g. reinitialize values like a timer.
func exit() -> void:
	move_state.exit()


func _jump() -> void:
	var impulse: = Vector2(_wall_normal, -1.0) * jump_strength
	var data: = {
		velocity = impulse,
		wall_jump = true
	}
	_fsm.swap("Move/Air", data)
