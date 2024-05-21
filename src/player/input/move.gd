## A parent state that abstracts and handles basic movement.
class_name PlayerMoveState extends FSMState

@export var max_speed_default: = Vector2(96.0, 300.0)
@export var acceleration_default: = Vector2(120000.0, 800.0)
@export var jump_impulse: = 320

var acceleration: = acceleration_default
var max_speed: = max_speed_default

@onready var player: = owner as Player


static func calculate_velocity(old_velocity: Vector2, maximum_speed: Vector2, accel: Vector2,
		delta: float, move_direction: Vector2) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += move_direction * accel * delta
	new_velocity.x = clamp(new_velocity.x, -maximum_speed.x, maximum_speed.x)
	new_velocity.y = clamp(new_velocity.y, -maximum_speed.y, maximum_speed.y)
	
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), 1.0)


func _ready() -> void:
	super._ready()
	assert(player, "Move input state must be owned by a CharacterBody2D!")


func unhandled_input(event: InputEvent) -> void:
	if player.is_on_floor() and event.is_action_pressed("jump"):
		_fsm.swap("Move/Air", {impulse = jump_impulse})


## Note that this is NOT the callback, but is called by child states that need to move the player.
func physics_process(delta: float) -> void:
	player.velocity = calculate_velocity(player.velocity, max_speed, acceleration, delta, 
		get_move_direction())
	
	if not is_equal_approx(player.velocity.x, 0.0):
		if player.velocity.x < 0.0:
			player.gfx.facing = CharacterGFX.Facing.LEFT
		
		else:
			player.gfx.facing = CharacterGFX.Facing.RIGHT
	
	if player.move_and_slide():
		pass # COllision
