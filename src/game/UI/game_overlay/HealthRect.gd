tool
extends TextureRect

export(bool) var active := true setget set_active
func set_active(value : bool) -> void:
	active = value
	update_health_rect()

func update_health_rect() -> void:
	if active:
		modulate = Color.white
	else:
		modulate = Color.black

