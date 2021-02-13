extends Control

onready var _pause_tab_container := $PauseTabContainer

func _ready():
	var _error : int = Flow.connect("pause_toggled", self, "_on_pause_toggled")

func _on_pause_toggled():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		show()
	else:
		hide()

func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_pause_tab_container.set_current_tab(PauseTab.TABS.MAIN)
	visible = true

func hide():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	visible = false
