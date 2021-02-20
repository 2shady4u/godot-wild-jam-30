tool
class_name YellowBrickMonster
extends StaticBody2D

onready var _animated_sprite := $AnimatedSprite

export(GLOBALS.DIRECTION) var direction := GLOBALS.DIRECTION.LEFT setget set_direction
func set_direction(value : int) -> void:
	direction = value
	if is_inside_tree():
		update_animation()

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_animation()

# warning-ignore:unused_signal
signal defeated

func _ready():
	if not Engine.editor_hint:
		add_to_group("enemies")

		var _error : int = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		set_physics_process(false)
	else:
		set_physics_process(false)

func update_animation() -> void:
	var animation_settings := GLOBALS.YELLOW_BRICK_MONSTER_ANIMATIONS_DICT
	animation_settings = animation_settings.get(dimension, {})
	animation_settings = animation_settings.get(direction, {})

	$AnimatedSprite.play(animation_settings.get("animation", "idle_down"))
	$AnimatedSprite.flip_h = animation_settings.get("flip_h", false)
	$AnimatedSprite.flip_v = animation_settings.get("flip_v", false)

	#$AnimatedSprite.offset = animation_settings.get("offset", Vector2.ZERO)

func _on_animation_finished():
	pass
