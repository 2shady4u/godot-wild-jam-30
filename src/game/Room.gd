class_name Room
extends Area2D

onready var _heart_on := $HeartOn
onready var _heart_off := $HeartOff

signal player_entered_room

func _ready():
	var _error : int = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is Player:
		emit_signal("player_entered_room")

func _on_heart_toggled(activated : bool) -> void:
	_heart_on.visible = activated
	_heart_off.visible = not activated
