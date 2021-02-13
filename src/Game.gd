extends Control

onready var _pause_UI := $CanvasLayer/PauseUI

func _ready():
	_pause_UI.hide()
