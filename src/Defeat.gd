extends Control

onready var _menu_button := $MC/VB/VB/MenuButton
onready var _quit_button := $MC/VB/VB/QuitButton

func _ready() -> void:
	var _error : int = _menu_button.connect("pressed", self, "_on_menu_button_pressed")

	if OS.get_name() == "HTML5":
		_quit_button.visible = false
	else:
		_quit_button.visible = true
		_error = _quit_button.connect("pressed", self, "_on_quit_button_pressed")

func update_tab() -> void:
	_menu_button.grab_focus()

func _on_menu_button_pressed():
	Flow.change_scene_to("menu")

func _on_quit_button_pressed():
	Flow.deferred_quit()
