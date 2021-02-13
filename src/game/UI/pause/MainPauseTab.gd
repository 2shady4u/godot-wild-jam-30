extends PauseTab

onready var _settings_button := $MC/VB/VB/SettingsButton

onready var _menu_button := $MC/VB/VB/MenuButton
onready var _quit_button := $MC/VB/VB/QuitButton

func _ready() -> void:
	var _error : int = _settings_button.connect("pressed", self, "_on_settings_button_pressed")

	_error = _menu_button.connect("pressed", self, "_on_menu_button_pressed")

	if OS.get_name() == "HTML5":
		_quit_button.visible = false
	else:
		_quit_button.visible = true
		_error = _quit_button.connect("pressed", self, "_on_quit_button_pressed")

func update_tab() -> void:
	_settings_button.grab_focus()

func _on_settings_button_pressed():
	emit_signal("button_pressed", TABS.SETTINGS)

func _on_menu_button_pressed():
	Flow.change_scene_to("menu")
