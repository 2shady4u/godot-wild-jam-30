tool
class_name Monkey
extends KinematicBody2D

onready var _animated_sprite := $AnimatedSprite

export(GLOBALS.DIRECTION) var direction := GLOBALS.DIRECTION.LEFT setget set_direction
func set_direction(value : int) -> void:
	direction = value
	if is_inside_tree():
		update_animation()

export(bool) var is_attacking := false setget set_is_attacking
func set_is_attacking(value : bool) -> void:
	is_attacking = value
	if is_inside_tree():
		update_animation()

var health := GLOBALS.MAX_MONKEY_HEALTH
var nav_path := []

var _is_movement_allowed := true

# warning-ignore:unused_signal
signal defeated
signal nav_path_requested

func _ready():
	if not Engine.editor_hint:
		add_to_group("enemies")

		var _error : int = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		set_physics_process(false)
	else:
		set_physics_process(false)

func _physics_process(delta):
	emit_signal("nav_path_requested")

	var move_direction := Vector2.ZERO
	var move_speed := GLOBALS.MONKEY_MOVE_SPEED

	if nav_path.size() > 0:
		var distance := position.distance_to(nav_path[0])
		if distance > move_speed * delta:
			var new_position := position.linear_interpolate(nav_path[0], move_speed/distance)
			move_direction = new_position - position
		else:
			nav_path.remove(0)

	var normalized_direction := move_direction.normalized()
	var _linear_velocity := move_and_slide(normalized_direction*move_speed)

func update_animation() -> void:
	if is_attacking:
		var animation_settings := GLOBALS.MONKEY_ATTACK_ANIMATIONS_DICT
		animation_settings = animation_settings.get(direction, {})

		$AnimatedSprite.play(animation_settings.get("animation", "idle_down"))
		$AnimatedSprite.flip_h = animation_settings.get("flip_h", false)
		$AnimatedSprite.flip_v = animation_settings.get("flip_v", false)

		#$AnimatedSprite.offset = animation_settings.get("offset", Vector2.ZERO)
	elif _is_movement_allowed:
		var animation_settings := GLOBALS.MONKEY_ANIMATIONS_DICT
		animation_settings = animation_settings.get(direction, {})

		$AnimatedSprite.play(animation_settings.get("animation", "idle_down"))
		$AnimatedSprite.flip_h = animation_settings.get("flip_h", false)
		$AnimatedSprite.flip_v = animation_settings.get("flip_v", false)

		#$AnimatedSprite.offset = animation_settings.get("offset", Vector2.ZERO)

func _on_animation_finished():
	if not is_attacking:
		_is_movement_allowed = true
	update_animation()
