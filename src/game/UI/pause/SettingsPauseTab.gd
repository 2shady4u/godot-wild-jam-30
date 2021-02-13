extends PauseTab

onready var _back_button := $MC/VB/BackButton

func _ready() -> void:
	var _error : int = _back_button.connect("pressed", self, "_on_back_button_pressed")

func update_tab() -> void:
	_back_button.grab_focus()

func _on_back_button_pressed() -> void:
	._on_back_button_pressed()
