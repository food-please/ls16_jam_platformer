extends Node2D


func _ready() -> void:
	$Background.show()
	$Player/States.start()
	
