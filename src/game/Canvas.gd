tool
extends Node2D

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_canvas()

onready var _rooms := $Rooms
onready var _camera_2d := $Camera2D
onready var _player := $Player

var _witch_castle_stream := preload("res://audio/music/witch_castle_3_bg.ogg")
var _emerald_city_stream := preload("res://audio/music/emerald_city_3_bg.ogg")

func _ready():
	if not Engine.editor_hint:
		for child in _rooms.get_children():
			var _error : int = child.connect("player_entered_room", self, "_on_player_entered_room", [child])
			_error = _player.connect("dimension_changed", child, "_on_dimension_changed")

			child.player = _player

		var _error : int = _player.connect("dimension_changed", self, "_on_dimension_changed")

		update_bg_music()
		_player.update_player()
	else:
		update_canvas()

func update_canvas():
	for child in $Rooms.get_children():
		(child as Room).dimension = dimension

func update_bg_music():
	match dimension:
		GLOBALS.DIMENSION.WITCH_CASTLE:
			AudioEngine.play_bg(_witch_castle_stream)
		GLOBALS.DIMENSION.EMERALD_CITY:
			AudioEngine.play_bg(_emerald_city_stream)

func _on_player_entered_room(room : Room) -> void:
	_player.active_room = room

	_camera_2d.global_position = room.global_position
	_camera_2d.zoom = room.camera_zoom*Vector2.ONE

func _on_dimension_changed() -> void:
	dimension = State.dimension

	update_canvas()
	update_bg_music()
