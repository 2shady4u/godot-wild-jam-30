class_name Target
extends Area2D

onready var _animated_sprite := $AnimatedSprite

func _ready() -> void:
	_animated_sprite.play("waiting")

func shatter() -> void:
	_animated_sprite.play("shatter")
	yield(_animated_sprite, "animation_finished")
	queue_free()

func is_player_inside() -> bool:
	var overlapping_bodies := get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is Player:
			return true
	return false
