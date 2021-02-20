tool
class_name Player
extends KinematicBody2D

onready var _interact_area := $InteractArea
onready var _attack_area := $AttackArea
onready var _animated_sprite := $AnimatedSprite
onready var _attack_timer := $AttackTimer

export(GLOBALS.DIRECTION) var direction := GLOBALS.DIRECTION.LEFT setget set_direction
func set_direction(value : int) -> void:
	direction = value
	if is_inside_tree():
		update_animation()

export(bool) var is_moving := false setget set_is_moving
func set_is_moving(value : bool) -> void:
	is_moving = value
	if is_inside_tree():
		update_animation()

export(bool) var is_attacking := false setget set_is_attacking
func set_is_attacking(value : bool) -> void:
	is_attacking = value
	if is_inside_tree():
		update_animation()

var active_room : Node2D

var _overlapping_stack := []
var _overlapping_body : PhysicsBody2D

var _is_movement_allowed := true
var _is_under_attack := false
var _attack_direction : Vector2

signal dimension_changed

var _wilhelm_scream_stream := preload("res://audio/sfx/wilhelm_scream.ogg")
var _axe_whoosh_stream := preload("res://audio/sfx/axe_whoosh.ogg")
var _axe_hit_stream := preload("res://audio/sfx/axe_hit.ogg")

func _ready():
	if not Engine.editor_hint:
		add_to_group("players")
		_attack_area.monitoring = false

		var _error := State.connect("player_health_changed", self, "_on_player_health_changed")
		_error = _interact_area.connect("area_entered", self, "_on_interact_area_entered")
		_error = _interact_area.connect("body_entered", self, "_on_interact_body_entered")
		_error = _attack_area.connect("body_entered", self, "_on_attack_body_entered")
		_error = _interact_area.connect("body_exited", self, "_on_interact_body_exited")
		_error = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		_error = _animated_sprite.connect("frame_changed", self, "_on_frame_changed")

		set_physics_process(true)
		set_process_input(true)
	else:
		set_physics_process(false)

	update_animation()

func decrease_health(enemy_position : Vector2):
	_is_under_attack = true
	_attack_direction = enemy_position - position
	State.decrease_player_health()

func respawn():
	global_position = active_room.global_position
	set_physics_process(true)
	set_process_input(true)

func _on_interact_area_entered(area : Area2D) -> void:
	if area is Pickup:
		area.pick_up()

func _on_interact_body_entered(body : PhysicsBody2D) -> void:
	if body is Door:
		if not body in _overlapping_stack:
			if (body as Door).type == GLOBALS.DOOR_TYPE.LOCKED:
				_overlapping_stack.append(body)
				update_overlapping_body()
	elif body is Lever:
		if not body in _overlapping_stack:
			_overlapping_stack.append(body)
			update_overlapping_body()

func _on_interact_body_exited(body : PhysicsBody2D) -> void:
	if body in _overlapping_stack:
		_overlapping_stack.erase(body)
		update_overlapping_body()

func _on_attack_body_entered(body : PhysicsBody2D):
	if body is Monkey:
		AudioEngine.play_effect(_axe_hit_stream)
		(body as Monkey).decrease_health(position)
		print("monkey!")

func update_overlapping_body():
	_overlapping_stack.sort_custom(self, "sort_overlapping_stack")
	if _overlapping_stack.empty():
		_overlapping_body = null
	else:
		_overlapping_body = _overlapping_stack.front()

func sort_overlapping_stack(a : PhysicsBody2D, b : PhysicsBody2D):
	var a_distance : float = a.global_position.distance_to(global_position)
	var b_distance : float = b.global_position.distance_to(global_position)
	if a_distance > b_distance:
		return true
	return false

func _physics_process(_delta):
	var move_direction := Vector2.ZERO
	var move_speed := GLOBALS.PLAYER_MOVE_SPEED

	if Input.is_action_pressed("move_down"):
		move_direction.y += 1
	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1

	var normalized_direction := move_direction.normalized()
	update_state(normalized_direction)
	if _is_movement_allowed:
		var _linear_velocity := move_and_slide(normalized_direction*move_speed)

	if active_room:
		var tile_index : int = active_room.get_cell(global_position)
		#print(tile_index)
		match tile_index:
			0:
				print("PLAYER FELL IN HOLE!")
				set_physics_process(false)
				set_process_input(true)
				State.decrease_player_health()

				AudioEngine.play_effect(_wilhelm_scream_stream)
				respawn()

func update_state(move_direction := Vector2.ZERO) -> void:
	var abs_direction := move_direction.abs()
	var old_is_moving := is_moving
	var old_direction := direction

	if abs_direction.x >= abs_direction.y:
		if move_direction.x > 0:
			direction = GLOBALS.DIRECTION.RIGHT
			is_moving = true
		elif move_direction.x < 0:
			direction = GLOBALS.DIRECTION.LEFT
			is_moving = true
		else:
			is_moving = false
	elif abs_direction.y > abs_direction.x:
		if move_direction.y > 0:
			direction = GLOBALS.DIRECTION.BOTTOM
			is_moving = true
		elif move_direction.y < 0:
			direction = GLOBALS.DIRECTION.TOP
			is_moving = true
		else:
			is_moving = false
	else:
		is_moving = false

	if old_direction != direction or old_is_moving != is_moving:
		update_animation()

func update_animation() -> void:
	if is_attacking:
		var animation_settings := GLOBALS.PLAYER_ATTACK_ANIMATIONS_DICT
		animation_settings = animation_settings.get(direction, {})

		$AnimatedSprite.play(animation_settings.get("animation", "idle_down"))
		$AnimatedSprite.flip_h = animation_settings.get("flip_h", false)
		$AnimatedSprite.flip_v = animation_settings.get("flip_v", false)

		$AnimatedSprite.offset = animation_settings.get("offset", Vector2.ZERO)

	elif _is_movement_allowed:
		var animation_settings := GLOBALS.PLAYER_ANIMATIONS_DICT
		animation_settings = animation_settings.get(is_moving, {})
		animation_settings = animation_settings.get(direction, {})

		$AnimatedSprite.play(animation_settings.get("animation", "idle_down"))
		$AnimatedSprite.flip_h = animation_settings.get("flip_h", false)
		$AnimatedSprite.flip_v = animation_settings.get("flip_v", false)

		$AnimatedSprite.offset = animation_settings.get("offset", Vector2.ZERO)

	match direction:
		GLOBALS.DIRECTION.LEFT:
			$AttackArea.rotation_degrees = 90
		GLOBALS.DIRECTION.RIGHT:
			$AttackArea.rotation_degrees = -90
		GLOBALS.DIRECTION.TOP:
			$AttackArea.rotation_degrees = 180
		GLOBALS.DIRECTION.BOTTOM:
			$AttackArea.rotation_degrees = 0

func _input(event) -> void:
	if event.is_action_pressed("toggle_heart") and State.has_heart:
		match State.dimension:
			GLOBALS.DIMENSION.WITCH_CASTLE:
				State.dimension = GLOBALS.DIMENSION.EMERALD_CITY
			GLOBALS.DIMENSION.EMERALD_CITY:
				State.dimension = GLOBALS.DIMENSION.WITCH_CASTLE
		update_player()

	if event.is_action_pressed("attack"):
		is_attacking = true
		if _is_movement_allowed:
			_is_movement_allowed = false
			toggle_attack_monitoring()
			AudioEngine.play_effect(_axe_whoosh_stream)
		update_animation()
	elif event.is_action_released("attack"):
		is_attacking = false

	if event.is_action_pressed("interact"):
		if _overlapping_body != null:
			if _overlapping_body is Door:
				if State.get_item_amount(GLOBALS.ITEM_TYPE.KEY) > 0:
					State.decrease_item_amount(GLOBALS.ITEM_TYPE.KEY)
					_overlapping_body.open()
			elif _overlapping_body is Lever:
				_overlapping_body.toggle()

	if event.is_action_pressed("increase_health"):
		State.player_health += 1
	elif event.is_action_pressed("decrease_health"):
		State.player_health -= 1

func _on_player_health_changed():
	pass

func _on_animation_finished():
	if not is_attacking:
		_is_movement_allowed = true
	update_animation()

func _on_frame_changed():
	if is_attacking:
		match _animated_sprite.frame:
			0:
				toggle_attack_monitoring()
				AudioEngine.play_effect(_axe_whoosh_stream)

func toggle_attack_monitoring():
	_attack_area.monitoring = true
	_attack_timer.start()
	yield(_attack_timer, "timeout")
	_attack_area.monitoring = false

func update_player():
	match State.dimension:
		GLOBALS.DIMENSION.WITCH_CASTLE:
			set_collision_layer_bit(1, false)
			set_collision_layer_bit(2, true)

			set_collision_mask_bit(1, false)
			set_collision_mask_bit(2, true)
		GLOBALS.DIMENSION.EMERALD_CITY:
			set_collision_layer_bit(1, true)
			set_collision_layer_bit(2, false)

			set_collision_mask_bit(1, true)
			set_collision_mask_bit(2, false)

	emit_signal("dimension_changed")
