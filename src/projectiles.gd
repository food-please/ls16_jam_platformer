extends Node2D


func _ready() -> void:
	Events.projectile_spawned.connect(_on_projectile_spawned)


func _on_projectile_spawned(node: Node2D) -> void:
	if node.get_parent():
		node.get_parent().remove_child(node)
	
	add_child(node)
