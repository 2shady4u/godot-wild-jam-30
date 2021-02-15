tool
class_name Door
extends StaticBody2D

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_door()

export(GLOBALS.DIRECTION) var direction : int setget set_direction
func set_direction(value : int) -> void:
	direction = value
	if is_inside_tree():
		update_door()

export(GLOBALS.DOOR_TYPE) var type : int setget set_type
func set_type(value : int) -> void:
	type = value
	if is_inside_tree():
		update_door()

signal opened

func _ready() -> void:
	update_door()

func open():
	emit_signal("opened")

func update_door() -> void:
	match direction:
		GLOBALS.DIRECTION.TOP:
			$Sprite.rotation_degrees = 0
		GLOBALS.DIRECTION.BOTTOM:
			$Sprite.rotation_degrees = 180
		GLOBALS.DIRECTION.LEFT:
			$Sprite.rotation_degrees = -90
		GLOBALS.DIRECTION.RIGHT:
			$Sprite.rotation_degrees = 90

	var door_settings : Dictionary = GLOBALS.DOORS_DICT.get(dimension, {})
	door_settings = door_settings.get(type, {})

	var texture : Texture = door_settings.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture
