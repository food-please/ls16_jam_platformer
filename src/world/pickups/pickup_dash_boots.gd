extends Pickup


# Override for pickup effect.
func _pickup() -> void:
	Constants.can_player_dash = true
	queue_free()


func _on_player_entered(_body: Node2D) -> void:
	var player = _body as Player
	if player:
		player.states.swap("Move/Idle")
		player.states.stop()
		await super._on_player_entered(_body)
		player.states.start()
