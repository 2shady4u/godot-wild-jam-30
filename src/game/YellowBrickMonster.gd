tool
class_name YellowBrickMonster
extends RigidBody2D

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

var nav_path := []

# warning-ignore:unused_signal
signal defeated
signal nav_path_requested

func _ready():
	if not Engine.editor_hint:
		add_to_group("enemies")

		var _error : int = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		set_physics_process(true)
	else:
		set_physics_process(false)

func _physics_process(delta):
	emit_signal("nav_path_requested")

	var move_direction := Vector2.ZERO
	if not nav_path.empty():
		move_direction = nav_path[0] - position

	var normalized_direction := move_direction.normalized()
	update_state(normalized_direction)

func update_state(move_direction := Vector2.ZERO) -> void:
	var abs_direction := move_direction.abs()
	var old_direction := direction

	if abs_direction.x >= abs_direction.y:
		if move_direction.x > 0:
			direction = GLOBALS.DIRECTION.RIGHT
		elif move_direction.x < 0:
			direction = GLOBALS.DIRECTION.LEFT
	elif abs_direction.y > abs_direction.x:
		if move_direction.y > 0:
			direction = GLOBALS.DIRECTION.BOTTOM
		elif move_direction.y < 0:
			direction = GLOBALS.DIRECTION.TOP

	if old_direction != direction:
		update_animation()

func update_animation() -> void:
	var animation_settings := GLOBALS.YELLOW_BRICK_MONSTER_ANIMATIONS_DICT
	animation_settings = animation_settings.get(dimension, {})
	animation_settings = animation_settings.get(direction, {})

	$AnimatedSprite.play(animation_settings.get("animation", "idle_down"))
	$AnimatedSprite.flip_h = animation_settings.get("flip_h", false)
	$AnimatedSprite.flip_v = animation_settings.get("flip_v", false)

	match dimension:
		GLOBALS.DIMENSION.EMERALD_CITY:
			mode = RigidBody2D.MODE_CHARACTER
		GLOBALS.DIMENSION.WITCH_CASTLE:
			mode = RigidBody2D.MODE_STATIC

	#$AnimatedSprite.offset = animation_settings.get("offset", Vector2.ZERO)

func _on_animation_finished():
	pass
