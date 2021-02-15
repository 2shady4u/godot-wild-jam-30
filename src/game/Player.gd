class_name Player
extends KinematicBody2D

onready var _interact_area := $InteractArea

var active_room : Node2D

var _overlapping_stack := []
var _overlapping_body : PhysicsBody2D

signal dimension_changed

func _ready():
	var _error := State.connect("player_health_changed", self, "_on_player_health_changed")
	_error = _interact_area.connect("area_entered", self, "_on_interact_area_entered")
	_error = _interact_area.connect("body_entered", self, "_on_interact_body_entered")
	_error = _interact_area.connect("body_exited", self, "_on_interact_body_exited")

	set_physics_process(true)
	set_process_input(true)

func respawn():
	global_position = active_room.global_position
	set_physics_process(true)
	set_process_input(true)

func _on_interact_area_entered(area : Area2D) -> void:
	if area is Pickup:
		area.emit_signal("picked_up")

func _on_interact_body_entered(body : PhysicsBody2D) -> void:
	if body is Door:
		if not body in _overlapping_stack:
			if (body as Door).type == Door.TYPE.LOCKED:
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
	var move_speed := 200

	if Input.is_action_pressed("move_down"):
		move_direction.y += 1
	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1

	var normalized_direction := move_direction.normalized()
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
				respawn()

func _input(event):
	if event.is_action_pressed("toggle_heart"):
		match State.dimension:
			GLOBALS.DIMENSION.WITCH_CASTLE:
				State.dimension = GLOBALS.DIMENSION.EMERALD_CITY
			GLOBALS.DIMENSION.EMERALD_CITY:
				State.dimension = GLOBALS.DIMENSION.WITCH_CASTLE
		update_player()

	if event.is_action_pressed("attack"):
		print("ATTACK!")

	if event.is_action_pressed("interact"):
		if _overlapping_body != null:
			if _overlapping_body is Door:
				if State.get_item_amount("key") > 0:
					State.decrease_item_amount("key")
					_overlapping_body.open()
			elif _overlapping_body is Lever:
				_overlapping_body.toggle()

	if event.is_action_pressed("increase_health"):
		State.player_health += 1
	elif event.is_action_pressed("decrease_health"):
		State.player_health -= 1

func _on_player_health_changed():
	pass

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
