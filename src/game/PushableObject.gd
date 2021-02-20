tool
class_name PushableObject
extends RigidBody2D

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_pushable_object()

func _ready():
	if not Engine.editor_hint:
		pass
		#var _error : int = connect("body_entered", self, "_on_body_entered")

	update_pushable_object()

#func push(direction : int):
#	var direction_vector := Vector2.ZERO
#	match direction:
#		GLOBALS.DIRECTION.LEFT:
#			direction_vector = Vector2.LEFT
#		GLOBALS.DIRECTION.RIGHT:
#			direction_vector = Vector2.RIGHT
#		GLOBALS.DIRECTION.TOP:
#			direction_vector = Vector2.UP
#		GLOBALS.DIRECTION.BOTTOM:
#			direction_vector = Vector2.DOWN
#
#	move_and_slide(direction_vector*64)

func update_pushable_object():
	var pushable_objects_dict : Dictionary = GLOBALS.PUSHABLE_OBJECTS_DICT.get(dimension, {})

	var texture : Texture = pushable_objects_dict.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture

	$Sprite.offset = pushable_objects_dict.get("offset", Vector2.ZERO)
