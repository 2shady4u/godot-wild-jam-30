tool
class_name Lever
extends StaticBody2D

export(bool) var active : bool setget set_active
func set_active(value : bool) -> void:
	active = value
	if is_inside_tree():
		update_lever()

var locked := false

signal toggled

func _ready():
	update_lever()

func toggle():
	if not locked:
		active = not active
		update_lever()

		emit_signal("toggled")

func update_lever():
	var lever_settings : Dictionary = GLOBALS.LEVERS_DICT.get(active, {})

	var texture : Texture = lever_settings.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture
