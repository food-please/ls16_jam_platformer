class_name CharacterGFX extends CollisionShape2D

enum Facing { LEFT=1, RIGHT=-1 }

signal animation_finished(animation_name: StringName)

var facing: = Facing.LEFT:
	set(value):
		facing = value
		if facing == Facing.LEFT:
			scale.x = -1.0
		
		else:
			scale.x = 1.0

@onready var anim: = $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	anim.animation_finished.connect(
		func(anim_name: StringName): animation_finished.emit(anim_name)
	)


func play(anim_name: StringName) -> void:
	if anim_name == anim.current_animation:
		return
	
	assert(anim_name in anim.get_animation_list(), 
		"%s GFX is trying to play '%s', which is not found in its animation " % [name, anim_name] +
		"list!")
	anim.play(anim_name)
