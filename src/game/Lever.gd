tool
class_name Lever
extends StaticBody2D

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_lever()

export(bool) var active : bool setget set_active
func set_active(value : bool) -> void:
	active = value
	if is_inside_tree():
		update_lever()

var locked := false

var _stream := preload("res://audio/sfx/lever_toggle.ogg")

signal toggled

func _ready():
	update_lever()

func toggle():
	if not locked:
		active = not active
		update_lever()

		AudioEngine.play_effect(_stream)
		emit_signal("toggled")

func update_lever():
	var lever_settings : Dictionary = GLOBALS.LEVERS_DICT.get(dimension, {})
	lever_settings = lever_settings.get(active, {})

	var texture : Texture = lever_settings.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture

	var offset : Vector2 = lever_settings.get("offset", Vector2.ZERO)
	$Sprite.offset = offset
