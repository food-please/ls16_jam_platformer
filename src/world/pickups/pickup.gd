class_name Pickup extends Area2D

@onready var _anim: = $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	body_entered.connect(_on_player_entered)


# Override for pickup effect.
func _pickup() -> void:
	pass


func _on_player_entered(_body: Node2D) -> void:
	if _anim.has_animation("pickup"):
		_anim.play("pickup")
		await _anim.animation_finished
	
	_pickup()
