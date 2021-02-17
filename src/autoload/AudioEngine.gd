extends Node

onready var _background := $Background
onready var _effects := $Effects

func play_bg(stream : AudioStream) -> void:
	_background.stream = stream
	_background.play()

func play_effect(stream : AudioStream) -> void:
	var effect := AudioStreamPlayer.new()
	effect.bus = "SFX"

	var _error : int = effect.connect("finished", self, "_on_audio_stream_player_finished", [effect])
	_effects.add_child(effect)

	effect.stream = stream
	effect.play()

func _on_audio_stream_player_finished(effect : AudioStreamPlayer) -> void:
	_effects.remove_child(effect)
	effect.queue_free()

func set_volume(audio_bus : int, value : float) -> void:
	var volume_db := linear2db(value/100.0)
	match audio_bus:
		GLOBALS.AUDIO_BUS.MASTER:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
		GLOBALS.AUDIO_BUS.MUSIC:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)
		GLOBALS.AUDIO_BUS.SFX:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_db)

func get_volume(audio_bus : int) -> float:
	var bus_name : String
	match audio_bus:
		GLOBALS.AUDIO_BUS.MASTER:
			bus_name = "Master"
		GLOBALS.AUDIO_BUS.MUSIC:
			bus_name = "Music"
		GLOBALS.AUDIO_BUS.SFX:
			bus_name = "SFX"
	var volume_db := AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))

	return db2linear(volume_db)*100.0
