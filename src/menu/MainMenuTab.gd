extends MenuTab

onready var _start_button := $MC/VB/VB/StartButton
onready var _settings_button := $MC/VB/VB/SettingsButton
onready var _quit_button := $MC/VB/QuitButton

func _ready():
	var _error : int = _start_button.connect("pressed", self, "_on_start_button_pressed")
	_error = _settings_button.connect("pressed", self, "_on_settings_button_pressed")

	# Hide the quit button if the OS is HTML!
	# Since this button won't work anyway...
	if OS.get_name() == "HTML5":
		_quit_button.visible = false
	else:
		_quit_button.visible = true
		_error = _quit_button.connect("pressed", self, "_on_quit_button_pressed")

func update_tab():
	_start_button.grab_focus()

func _on_start_button_pressed():
	#var _error := State.load_stateJSON(Flow.DEFAULT_CONTEXT_PATH)
	Flow.change_scene_to("game")

func _on_settings_button_pressed():
	emit_signal("button_pressed", TABS.SETTINGS)
