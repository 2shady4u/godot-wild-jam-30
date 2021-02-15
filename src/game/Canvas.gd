extends Node2D

onready var _rooms := $Rooms
onready var _camera_2d := $Camera2D
onready var _player := $Player

func _ready():
	for child in _rooms.get_children():
		var _error : int = child.connect("player_entered_room", self, "_on_player_entered_room", [child])
		_error = _player.connect("dimension_changed", child, "_on_dimension_changed")

		child.player = _player

	_player.update_player()

func _on_player_entered_room(room : Room) -> void:
	_player.active_room = room

	_camera_2d.global_position = room.global_position
	_camera_2d.zoom = room.camera_zoom*Vector2.ONE
