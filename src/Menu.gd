# The game's main menu...
extends Control

onready var _menu_tab_container := $MenuTabContainer

var _witch_castle_stream := preload("res://audio/music/witch_castle_2_bg.ogg")

func _ready():
	_menu_tab_container.set_current_tab(MenuTab.TABS.MAIN)

	AudioEngine.play_bg(_witch_castle_stream)
