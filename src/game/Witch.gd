tool
class_name Witch
extends StaticBody2D

export var attack_timer_timeout = 8.0

onready var _animated_sprite := $AnimatedSprite

var yellow_brick_road_present = false

# warning-ignore:unused_signal
signal defeated
signal thrown_bottles
# warning-ignore:unused_signal
signal summon

func _ready():
	if not Engine.editor_hint:
		add_to_group("witch")

		var _error : int = _animated_sprite.connect("animation_finished", self, "_on_animation_finished")
		set_physics_process(false)
	else:
		set_physics_process(false)

	var _error : int = $Timer.connect("timeout", self, "_on_timer_timeout")

func update_animation() -> void:
	pass

func _on_animation_finished():
	pass


func _input(_event):
	# debug
	if Input.is_action_just_pressed("attack"):
		start()


func _on_timer_timeout():
	throw()


func start():
	$Timer.start(attack_timer_timeout)

func throw():
	# sorry for barf Pietsan
	_animated_sprite.play("throw")
	yield(_animated_sprite, "frame_changed")
	yield(_animated_sprite, "frame_changed")
	$AnimationPlayer.play("bottle_throw")
	yield(_animated_sprite, "animation_finished")
	_animated_sprite.play("idle")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("thrown_bottles")
