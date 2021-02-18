tool
class_name PushableObject
extends RigidBody2D

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_pushable_object()

func _ready():
	update_pushable_object()

func update_pushable_object():
	var pushable_objects_dict : Dictionary = GLOBALS.PUSHABLE_OBJECTS_DICT.get(dimension, {})

	var texture : Texture = pushable_objects_dict.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture

	$Sprite.offset = pushable_objects_dict.get("offset", Vector2.ZERO)
