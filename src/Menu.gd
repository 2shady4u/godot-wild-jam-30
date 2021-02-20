# The game's main menu...
extends Control

onready var _menu_tab_container := $MenuTabContainer

var _menu_stream := preload("res://audio/music/menu_bg.ogg")

func _ready():
	_menu_tab_container.set_current_tab(MenuTab.TABS.MAIN)

	AudioEngine.play_bg(_menu_stream)
