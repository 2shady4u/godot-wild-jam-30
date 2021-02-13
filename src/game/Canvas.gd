extends Node2D

onready var _rooms := $Rooms
onready var _camera_2d := $Camera2D
onready var _player := $Player

var active_room : Room

func _ready():
	for child in _rooms.get_children():
		var _error : int = child.connect("player_entered_room", self, "_on_player_entered_room", [child])
		_error = _player.connect("heart_toggled", child, "_on_heart_toggled")

	_player.update_player()

func _on_player_entered_room(room : Room) -> void:
	active_room = room
	_camera_2d.global_position = active_room.global_position
	_camera_2d.zoom = active_room.camera_zoom*Vector2.ONE
