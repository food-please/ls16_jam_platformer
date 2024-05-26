@tool
class_name Room extends Node2D

@export_range(1, 10, 1, "or_greater") var room_width: = 1:
	set(value):
		room_width = value
		
		if not is_inside_tree():
			await ready
		_update_visualizer()

@export_range(1, 10, 1, "or_greater") var room_height: = 1:
	set(value):
		room_height = value
		
		if not is_inside_tree():
			await ready
		_update_visualizer()

@onready var _camera_anchor: = $CameraAnchor as Area2D
@onready var _camera_anchor_shape: = $CameraAnchor/CollisionShape2D as CollisionShape2D
@onready var _visualizer: = $RoomVisualizer as RoomVisualizer


func _ready() -> void:
	_update_visualizer()
	
	if not Engine.is_editor_hint():
		_camera_anchor.area_entered.connect(_on_camera_anchor_player_collider)
		_visualizer.hide()

	
#
#
#func _notification(msg: int) -> void:
	#match msg:
		#NOTIFICATION_CHILD_ORDER_CHANGED:
			#print("Children changed!")


func get_room_bounds() -> Rect2:
	return Rect2(
			global_position.x,
			global_position.y,
			room_width * Constants.TILE_SIZE.x * Constants.SCREEN_SIZE_TILES.x,
			room_height * Constants.TILE_SIZE.y * Constants.SCREEN_SIZE_TILES.y
		)


func _update_visualizer() -> void:
	var new_bounds: = get_room_bounds()
	new_bounds.position.x = 0
	new_bounds.position.y = 0
	
	_camera_anchor.position = new_bounds.size/2
	
	_camera_anchor_shape.shape = RectangleShape2D.new()
	_camera_anchor_shape.shape.size = new_bounds.size - Vector2(Constants.TILE_SIZE)
	
	if _visualizer:
		_visualizer.draw_dimensions = new_bounds


func _on_camera_anchor_player_collider(area: Area2D) -> void:
	if area.owner is Player:
		Events.room_entered.emit(self)
