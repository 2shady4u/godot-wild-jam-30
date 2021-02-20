extends Control

onready var _pause_UI := $CanvasLayer/PauseUI

func _ready():
	# This needs to be called if the game is started with this as the initial scene!
	Flow._flow_state = Flow.STATE.GAME
	# Make sure to reset the state!
	State.reset()

	_pause_UI.hide()
