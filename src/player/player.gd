class_name Player extends CharacterBody2D

const FLOOR_NORMAL: = Vector2.UP

var is_active: = true:
	set(value):
		is_active = value
		
		if not is_inside_tree():
			await ready
		
		collider.disabled = !is_active

@onready var collider: = $CollisionShape2D as CollisionShape2D
#@onready var gfx: = $Sprite2D as AnimatedSprite2D
@onready var gfx: = $GFX as CharacterGFX
@onready var states: = $States as FSM
