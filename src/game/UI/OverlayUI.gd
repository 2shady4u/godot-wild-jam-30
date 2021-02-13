extends Control

const SCENE_HEALTH_RECT := preload("res://src/game/UI/game_overlay/HealthRect.tscn")

onready var _health_hbox := $HB/Control/MC/HealthHBox

func _ready():
	var _error := State.connect("player_health_changed", self, "_on_player_health_changed")

	for child in _health_hbox.get_children():
		_health_hbox.remove_child(child)
		child.queue_free()

	for _i in range(Globals.MAX_HEALTH):
		var health_rect := SCENE_HEALTH_RECT.instance()
		_health_hbox.add_child(health_rect)

	update_overlay()

func _on_player_health_changed():
	update_overlay()

func update_overlay():
	var i := 0
	for child in _health_hbox.get_children():
		if State.player_health > i:
			child.active = true
		else:
			child.active = false
		i += 1
