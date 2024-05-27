class_name Player extends CharacterBody2D

const FLOOR_NORMAL: = Vector2.UP

signal hurt

var is_active: = true:
	set(value):
		is_active = value
		
		if not is_inside_tree():
			await ready
		
		gfx.disabled = !is_active

@onready var hitbox: = $GFX/Hitbox as Area2D
@onready var gfx: = $GFX as CharacterGFX
@onready var states: = $States as FSM
@onready var wall_searcher: = $GFX/WallSearcher as Area2D


func _ready() -> void:
	hitbox.area_entered.connect(_on_signal)
	hitbox.body_entered.connect(_on_body_signal)


func can_wall_jump() -> bool:
	return wall_searcher.has_overlapping_bodies()


func _on_signal(area: Area2D) -> void:
	_on_body_signal(area)


func _on_body_signal(_body: Node2D) -> void:
	print("Ouch!")
	hurt.emit()
