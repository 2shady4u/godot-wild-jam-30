tool
extends VBoxContainer

export(GLOBALS.AUDIO_BUS) var audio_bus := GLOBALS.AUDIO_BUS.MASTER setget set_audio_bus
func set_audio_bus(value : int) -> void:
	audio_bus = value
	if is_inside_tree():
		update_volume_vbox()

onready var _volume_slider := $HB/VolumeSlider
onready var _volume_label := $HB/VolumeLabel

func _ready():
	if not Engine.editor_hint:
		var _error : int = _volume_slider.connect("value_changed", self, "_on_slider_value_changed")
		_volume_slider.value = AudioEngine.get_volume(audio_bus)

	update_volume_vbox()

func _on_slider_value_changed(value : float):
	_volume_label.text = "%3d %%" % value

	AudioEngine.set_volume(audio_bus, value)

func update_volume_vbox() -> void:
	match audio_bus:
		GLOBALS.AUDIO_BUS.MASTER:
			$HB/Label.text = "Master"
		GLOBALS.AUDIO_BUS.MUSIC:
			$HB/Label.text = "Music"
		GLOBALS.AUDIO_BUS.SFX:
			$HB/Label.text = "SFX"
