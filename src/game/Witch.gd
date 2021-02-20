tool
class_name Witch
extends StaticBody2D

export var attack_timer_timeout = 4.0

onready var _animated_sprite := $AnimatedSprite

var yellow_brick_road_present = false

# warning-ignore:unused_signal
signal defeated

func _ready():
	if not Engine.editor_hint:
		add_to_group("witch")

		var _error : int = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		set_physics_process(false)
	else:
		set_physics_process(false)

func update_animation() -> void:
	pass

func _on_animation_finished():
	pass
