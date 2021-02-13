extends Node

enum STATE {MENU, INTRO, GAME, OUTRO, DEFEAT}

var _state_dict := {
	"menu": {
		"packed_scene": preload("res://src/Menu.tscn"),
		"state": STATE.MENU
		},
	"intro": {
		"packed_scene": preload("res://src/Intro.tscn"),
		"state": STATE.INTRO
		},
	"game": {
		"packed_scene": preload("res://src/Game.tscn"),
		"state": STATE.GAME
		},
	"outro": {
		"packed_scene": preload("res://src/Outro.tscn"),
		"state": STATE.OUTRO
		},
	"defeat": {
		"packed_scene": preload("res://src/Defeat.tscn"),
		"state": STATE.DEFEAT
		},
	}
var _flow_state : int = STATE.MENU

signal pause_toggled

func _ready():
	pass # Replace with function body.

func _unhandled_input(event : InputEvent):
	if _flow_state == STATE.GAME:
		if event.is_action_pressed("toggle_paused"):
			emit_signal("pause_toggled")

func deferred_quit() -> void:
## Quit the game during an idle frame.
	get_tree().quit()

func change_scene_to(key : String) -> void:
	if _state_dict.has(key):
		var state_settings : Dictionary = _state_dict[key]
		var packed_scene : PackedScene = state_settings.packed_scene
		_flow_state = state_settings.state

		var error := get_tree().change_scene_to(packed_scene)
		get_tree().paused = false
		if error != OK:
			push_error("Failed to change scene to '{0}'.".format([key]))
		else:
			print("Succesfully changed scene to '{0}'.".format([key]))
	else:
		push_error("Requested scene '{0}' was not recognized... ignoring call for changing scene.".format([key]))
