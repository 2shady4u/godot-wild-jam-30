tool
class_name Pickup
extends Area2D

onready var _sprite := $Sprite

export(String) var id := ""

export(Texture) var texture := load("res://icon.png") setget set_texture
func set_texture(value : Texture) -> void:
	texture = value
	if is_inside_tree():
		update_pickup()

# warning-ignore:unused_signal
signal picked_up

func _ready():
	update_pickup()

func update_pickup():
	$Sprite.texture = texture
