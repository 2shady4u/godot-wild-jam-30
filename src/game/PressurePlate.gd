tool
class_name PressurePlate
extends Area2D

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_pressure_plate()

export(bool) var pressed : bool setget set_pressed
func set_pressed(value : bool) -> void:
	pressed = value
	if is_inside_tree():
		update_pressure_plate()

var _overlapping_stack := []
var _stream := preload("res://audio/sfx/pressure_plate_press.ogg")

signal pressed

func _ready():
	if not Engine.editor_hint:
		var _error := connect("body_entered", self, "_on_body_entered")
		_error = connect("body_exited", self, "_on_body_exited")

	update_pressed()

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is Player or body is PushableObject:
		if not body in _overlapping_stack:
			_overlapping_stack.append(body)
			update_pressed()

func _on_body_exited(body : PhysicsBody2D) -> void:
	if body is Player or body is PushableObject:
		if body in _overlapping_stack:
			_overlapping_stack.erase(body)
			update_pressed()

func update_pressed():
	if _overlapping_stack.empty():
		self.pressed = false
	elif not pressed:
		self.pressed = true
		AudioEngine.play_effect(_stream)
		emit_signal("pressed")

func update_pressure_plate():
	var pressure_plate_settings : Dictionary = GLOBALS.PRESSURE_PLATES_DICT.get(dimension, {})
	pressure_plate_settings = pressure_plate_settings.get(pressed, {})

	var texture : Texture = pressure_plate_settings.get("texture", preload("res://icon.png"))
	$Sprite.texture = texture
