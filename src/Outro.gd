extends Control

onready var _menu_button := $MC/VB/VB/MenuButton

func _ready():
	var _error : int = _menu_button.connect("pressed", self, "_on_menu_button_pressed")

func _on_menu_button_pressed():
	Flow.change_scene_to("menu")
