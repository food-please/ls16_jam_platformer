extends FSMState

@export var initial_velocity: = Vector2(64.0, 64.0)
@export var acceleration: = Vector2(0.0, 800.0)
@export var max_speed: = Vector2(96.0, 300.0)

var move_direction: = Vector2(1.0, -1.0)

@onready var player: = owner as Player
@onready var timer: = $Timer as Timer


func _ready() -> void:
	super._ready()
	
	timer.timeout.connect(_on_timer_timeout)


func _unhandled_input(_event: InputEvent) -> void:
	return


func _physics_process(delta: float) -> void:
	player.velocity = calculate_velocity(player.velocity, max_speed, acceleration, delta)
	print(player.velocity)
	
	if not is_equal_approx(player.velocity.x, 0.0):
		if player.velocity.x < 0.0:
			player.gfx.facing = CharacterGFX.Facing.RIGHT
		
		else:
			player.gfx.facing = CharacterGFX.Facing.LEFT
	
	if player.move_and_slide():
		pass # COllision


func make_connections() -> void:
	super.make_connections()
	timer.paused = false


func break_connections() -> void:
	super.break_connections()
	timer.paused = true


# Initialize the state. E.g. change the animation.
func enter(_data: = {}) -> void:
	move_direction.x = player.gfx.facing
	
	player.velocity = initial_velocity * move_direction
	player.gfx.play("hurt")
	print(player.velocity)
	
	timer.start()
	print(player.gfx.facing, " ", move_direction.x)


# Clean up the state.
func exit() -> void:
	super.exit()


func calculate_velocity(old_velocity: Vector2, maximum_speed: Vector2, accel: Vector2,
		delta: float) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += accel * delta
	new_velocity.x = clamp(new_velocity.x, -maximum_speed.x, maximum_speed.x)
	new_velocity.y = clamp(new_velocity.y, -maximum_speed.y, maximum_speed.y)
	
	return new_velocity


func _on_timer_timeout() -> void:
	if player.hitbox.has_overlapping_areas() or player.hitbox.has_overlapping_bodies():
		player.velocity = initial_velocity * move_direction
		timer.start()
	
	else:
		if player.is_on_floor():
			_fsm.swap("Move/Idle")
		
		else:
			_fsm.swap("Move/Air")
