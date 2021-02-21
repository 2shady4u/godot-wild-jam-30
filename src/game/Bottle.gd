class_name Bottle
extends Sprite

const FALL_SPEED := 350
const ROTATE_SPEED := PI

var _distance := 1000

signal shattered

func set_distance(distance : int):
	_distance = int(position.y) + distance

func _process(delta):
	position += FALL_SPEED * delta * Vector2.DOWN
	rotation += ROTATE_SPEED * delta
	if position.y > _distance:
		emit_signal("shattered")
		queue_free()

