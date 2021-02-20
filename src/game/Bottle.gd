extends Sprite

const FALL_SPEED = 350
const ROTATE_SPEED = PI
var _distance = 1000

signal shatter

func _ready():
	pass # Replace with function body.

func set_distance(distance: int):
	_distance = position.y + distance

func _process(delta):
	position += FALL_SPEED * delta * Vector2(0, 1)
	rotation += ROTATE_SPEED * delta
	if position.y > _distance:
		emit_signal("shatter")
		queue_free()

