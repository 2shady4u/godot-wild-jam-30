extends Control

onready var _progress_bar := $MC/VB/ProgressBar
onready var _replay_button := $MC/VB/ReplayButton
onready var _menu_button := $MC/VB/MenuButton

onready var _audio_stream_player := $AudioStreamPlayer

var _stream_length := 0.0

func _ready():
	var _error : int = _menu_button.connect("pressed", self, "_on_menu_button_pressed")
	_error = _replay_button.connect("pressed", self, "_on_replay_button_pressed")
	_error = _audio_stream_player.connect("finished", self, "_on_audio_stream_player_finished")

	AudioEngine.stop_bg()

	_menu_button.grab_focus()
	var audio_stream := (_audio_stream_player as AudioStreamPlayer).stream
	_stream_length = audio_stream.get_length()

	start_dialogue()

func start_dialogue() -> void:
	_audio_stream_player.play()

	_replay_button.disabled = true
	set_process(true)

func _process(_delta : float) -> void:
	var playback_position := (_audio_stream_player as AudioStreamPlayer).get_playback_position()
	if _stream_length != 0.0:
		_progress_bar.value = 100.0*playback_position/_stream_length

func _on_menu_button_pressed():
	Flow.change_scene_to("menu")

func _on_replay_button_pressed() -> void:
	start_dialogue()

func _on_audio_stream_player_finished() -> void:
	_replay_button.disabled = false
	set_process(false)
