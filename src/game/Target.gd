extends Area2D


onready var _animated_sprite := $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("waiting")



func shatter():
	_animated_sprite.play("shatter")
	yield(_animated_sprite, "animation_finished")
	queue_free()


func is_player_inside():
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is Player:
			return true
	return false
