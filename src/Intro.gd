extends Control

onready var _start_button := $MC/VB/StartButton

func _ready():
	var _error : int = _start_button.connect("pressed", self, "_on_start_button_pressed")

	_start_button.grab_focus()

func _on_start_button_pressed():
	# Make sure to reset the state!
	State.reset()
	Flow.change_scene_to("game")
