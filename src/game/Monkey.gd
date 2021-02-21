tool
class_name Monkey
extends KinematicBody2D

onready var _animated_sprite := $AnimatedSprite
onready var _attack_area := $AttackArea
onready var _attack_timer := $AttackTimer

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

var health := GLOBALS.MAX_MONKEY_HEALTH setget set_player_health
func set_player_health(value : int) -> void:
	health = int(clamp(value, 0, GLOBALS.MAX_MONKEY_HEALTH))
	if health == 0:
		emit_signal("defeated")

var nav_path := []

var _is_movement_allowed := true
var _is_under_attack := false
var _attack_direction : Vector2

# warning-ignore:unused_signal
signal defeated
signal nav_path_requested

func _ready():
	if not Engine.editor_hint:
		add_to_group("enemies")
		_attack_area.monitoring = false

		var _error : int = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		_error = _attack_area.connect("body_entered", self, "_on_attack_body_entered")
		set_physics_process(true)
	else:
		set_physics_process(false)

func decrease_health(player_position : Vector2):
	_is_under_attack = true
	_attack_direction = player_position - global_position
	self.health -= 1

func _physics_process(delta):
	emit_signal("nav_path_requested")

	if not _is_under_attack:
		var move_direction := Vector2.ZERO
		var move_speed := GLOBALS.MONKEY_MOVE_SPEED

		if nav_path.size() > 0:
			var distance := position.distance_to(nav_path[0])
			if distance > move_speed * delta:
				var new_position := position.linear_interpolate(nav_path[0], move_speed/distance)
				move_direction = new_position - position
			else:
				nav_path.remove(0)

		if nav_path.size() > 0:
			var distance := position.distance_to(nav_path.back())
			if distance < 36:
				is_attacking = true
				if _is_movement_allowed:
					_is_movement_allowed = false
					toggle_attack_monitoring()
					update_animation()
				else:
					is_attacking = false

		var normalized_direction := move_direction.normalized()
		update_state(normalized_direction)
		if _is_movement_allowed:
			var _linear_velocity := move_and_slide(normalized_direction*move_speed)
	else:
		var move_speed := 2*GLOBALS.MONKEY_MOVE_SPEED
		var _linear_velocity := move_and_slide(-_attack_direction*move_speed)
		_is_under_attack = false

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

	match direction:
		GLOBALS.DIRECTION.LEFT:
			$AttackArea.rotation_degrees = 90
		GLOBALS.DIRECTION.RIGHT:
			$AttackArea.rotation_degrees = -90
		GLOBALS.DIRECTION.TOP:
			$AttackArea.rotation_degrees = 180
		GLOBALS.DIRECTION.BOTTOM:
			$AttackArea.rotation_degrees = 0

func _on_attack_body_entered(body : PhysicsBody2D):
	if body.is_in_group("players"):
		body.decrease_health(global_position)
		print("player!")

func toggle_attack_monitoring():
	_attack_area.monitoring = true
	_attack_timer.start()
	yield(_attack_timer, "timeout")
	_attack_area.monitoring = false

func _on_animation_finished():
	if not is_attacking:
		_is_movement_allowed = true
	update_animation()
