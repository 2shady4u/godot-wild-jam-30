class_name Player
extends KinematicBody2D

var health := Globals.MAX_HEALTH;
var heart_activated := false

signal heart_toggled

func _ready():
	var _error := State.connect("player_health_changed", self, "_on_player_health_changed")

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
