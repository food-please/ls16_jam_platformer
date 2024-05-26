class_name Player extends CharacterBody2D

const FLOOR_NORMAL: = Vector2.UP

var is_active: = true:
	set(value):
		is_active = value
		
		if not is_inside_tree():
			await ready
		
		gfx.disabled = !is_active

@onready var gfx: = $GFX as CharacterGFX
@onready var states: = $States as FSM
@onready var wall_searcher: = $GFX/WallSearcher as Area2D


func can_wall_jump() -> bool:
	return wall_searcher.has_overlapping_bodies()
