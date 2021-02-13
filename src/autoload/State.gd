extends Node

signal player_health_changed

var player_health := Globals.MAX_HEALTH setget set_player_health
func set_player_health(value : int) -> void:
	player_health = int(clamp(value, 0, Globals.MAX_HEALTH))
	if player_health == 0:
		Flow.change_scene_to("defeat")
	else:
		emit_signal("player_health_changed")

func reset():
	player_health = Globals.MAX_HEALTH
