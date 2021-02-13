class_name Player
extends KinematicBody2D

onready var _interact_area := $InteractArea

var heart_activated := false
var active_room : Node2D

signal heart_toggled

func _ready():
	var _error := State.connect("player_health_changed", self, "_on_player_health_changed")
	_error = _interact_area.connect("area_entered", self, "_on_interact_area_entered")
	_error = _interact_area.connect("body_entered", self, "_on_interact_body_entered")

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
		if (body as Door).type == Door.TYPE.LOCKED:
			if State.get_item_amount("key") > 0:
				State.decrease_item_amount("key")
				body.emit_signal("opened")
	elif body is Lever:
		print("lever!!!")

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
			3:
				print("PLAYER FELL IN HOLE!")
				set_physics_process(false)
				set_process_input(true)
				State.decrease_player_health()
				respawn()

func _input(event):
	if event.is_action_pressed("toggle_heart"):
		heart_activated = not heart_activated
		update_player()
	if event.is_action_pressed("attack"):
		print("ATTACK!")

	if event.is_action_pressed("increase_health"):
		State.player_health += 1
	elif event.is_action_pressed("decrease_health"):
		State.player_health -= 1

func _on_player_health_changed():
	pass

func update_player():
	print("updating player..." + str(heart_activated))
	set_collision_layer_bit(1, heart_activated)
	set_collision_layer_bit(2, not heart_activated)

	set_collision_mask_bit(1, heart_activated)
	set_collision_mask_bit(2, not heart_activated)

	emit_signal("heart_toggled", heart_activated)
