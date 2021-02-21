tool
class_name Witch
extends StaticBody2D

export(float) var attack_timer_timeout := 8.0

onready var _visibility_enabler := $VisibilityEnabler2D
onready var _animated_sprite := $AnimatedSprite
onready var _attack_timer := $Timer

var health := GLOBALS.MAX_WITCH_HEALTH setget set_health
func set_health(value : int) -> void:
	health = int(clamp(value, 0, GLOBALS.MAX_WITCH_HEALTH))
	if health == 0:
		emit_signal("defeated")

var is_invincible := false

var _cackle_streams := [
	preload("res://audio/sfx/cackle_1.ogg"),
	preload("res://audio/sfx/cackle_2.ogg"),
	preload("res://audio/sfx/cackle_3.ogg")
]

var _smash_stream := preload("res://audio/sfx/cauldron_smash.ogg")

# warning-ignore:unused_signal
signal defeated
signal bottles_thrown
signal smashed
signal done_smashing
# warning-ignore:unused_signal
signal summon

func _ready():
	if not Engine.editor_hint:
		add_to_group("enemies")

		_animated_sprite.play("idle")

		var _error : int = _attack_timer.connect("timeout", self, "_on_timer_timeout")
		_error = _visibility_enabler.connect("screen_entered", self, "_on_screen_entered")
		_error = _visibility_enabler.connect("screen_exited", self, "_on_screen_exited")

	set_physics_process(false)

func _on_screen_entered():
	print("screen entered witch!")
	_attack_timer.start(attack_timer_timeout)

func _on_screen_exited():
	_attack_timer.stop()

func decrease_health() -> void:
	is_invincible = true
	self.health -= 1
	_attack_timer.stop()

	smash()

func _on_timer_timeout():
	print("throwing potions!")
	AudioEngine.play_effect(_cackle_streams[randi() % _cackle_streams.size()])
	throw()

func smash():
	_animated_sprite.play("smash")
	AudioEngine.play_effect(_smash_stream)

	yield(_animated_sprite, "animation_finished")
	AudioEngine.play_effect(_smash_stream)
	emit_signal("smashed")
	yield(_animated_sprite, "animation_finished")
	AudioEngine.play_effect(_smash_stream)
	emit_signal("smashed")
	yield(_animated_sprite, "animation_finished")
	AudioEngine.play_effect(_smash_stream)
	emit_signal("smashed")
	yield(_animated_sprite, "animation_finished")
	AudioEngine.play_effect(_smash_stream)
	emit_signal("smashed")
	yield(_animated_sprite, "animation_finished")
	AudioEngine.play_effect(_smash_stream)
	emit_signal("smashed")

	emit_signal("done_smashing")

	is_invincible = false
	_attack_timer.start()

func throw():
	# sorry for barf Pietsan
	_animated_sprite.play("throw")
	yield(_animated_sprite, "frame_changed")
	yield(_animated_sprite, "frame_changed")
	$AnimationPlayer.play("bottle_throw")
	yield(_animated_sprite, "animation_finished")
	_animated_sprite.play("idle")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("bottles_thrown", get_amount_of_bottles())

func get_amount_of_bottles() -> int:
	return (GLOBALS.MAX_WITCH_HEALTH - health)*20 + 20
