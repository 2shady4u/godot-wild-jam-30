class_name Enemy
extends KinematicBody2D

var health := Globals.MAX_MONKEY_HEALTH
var nav_path := []

# warning-ignore:unused_signal
signal defeated
signal nav_path_requested

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	emit_signal("nav_path_requested")

	var move_direction := Vector2.ZERO
	var move_speed := Globals.MONKEY_MOVE_SPEED

	if nav_path.size() > 0:
		var distance := position.distance_to(nav_path[0])
		if distance > move_speed * delta:
			var new_position := position.linear_interpolate(nav_path[0], move_speed/distance)
			move_direction = new_position - position
		else:
			nav_path.remove(0)

	var normalized_direction := move_direction.normalized()
	var _linear_velocity := move_and_slide(normalized_direction*move_speed)
