class_name Room
extends Area2D

onready var _heart_on := $HeartOn
onready var _heart_off := $HeartOff
onready var _pickups := $Pickups

export(float) var camera_zoom := 1.0

signal player_entered_room

func _ready():
	var _error : int = connect("body_entered", self, "_on_body_entered")

	for child in _pickups.get_children():
		child.connect("picked_up", self, "_on_pickup_picked_up", [child])

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is Player:
		emit_signal("player_entered_room")

func _on_pickup_picked_up(pickup : Pickup) -> void:
	Flow.pick_up_pickup(pickup.id)

	# Delete the pickup!
	_pickups.remove_child(pickup)
	pickup.queue_free()

func _on_heart_toggled(activated : bool) -> void:
	_heart_on.visible = activated
	_heart_off.visible = not activated
