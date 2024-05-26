@tool
class_name RoomVisualizer extends Node2D


@export var draw_dimensions: Rect2:
	set(value):
		draw_dimensions = value
		queue_redraw()

@export var line_thickness: = -1.0:
	set(value):
		line_thickness = value
		queue_redraw()


func _draw() -> void:
	draw_rect(draw_dimensions, Color.LIGHT_SALMON, false, line_thickness)
