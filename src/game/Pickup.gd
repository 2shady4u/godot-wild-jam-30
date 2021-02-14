tool
class_name Pickup
extends Area2D

onready var _sprite := $Sprite

export(String) var id := "" setget set_id
func set_id(value : String) -> void:
	id = value
	if is_inside_tree():
		update_pickup()

# warning-ignore:unused_signal
signal picked_up

func _ready():
	update_pickup()

func update_pickup():
	var pickup_settings : Dictionary = GLOBALS.PICKUPS_DICT.get(id, {})

	var texture : Texture = pickup_settings.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture

	var hframes : int = pickup_settings.get("hframes", 1)
	$Sprite.hframes = hframes
	# Reset the sprite!
	$Sprite.frame = 0
	$Sprite.frame_coords = Vector2.ZERO

	var animation : Animation = pickup_settings.get("animation", null)
	for name in $AnimationPlayer.get_animation_list():
		$AnimationPlayer.remove_animation(name)
	if animation:
		$AnimationPlayer.add_animation(animation.resource_name, animation)
		$AnimationPlayer.play(animation.resource_name)
