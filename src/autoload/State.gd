extends Node

signal player_health_changed
signal item_amount_changed
signal dimension_changed
signal heart_acquired
signal tutorial_requested

var player_health := GLOBALS.MAX_PLAYER_HEALTH setget set_player_health
func set_player_health(value : int) -> void:
	player_health = int(clamp(value, 0, GLOBALS.MAX_PLAYER_HEALTH))
	if player_health == 0:
		Flow.change_scene_to("defeat")
	else:
		emit_signal("player_health_changed")

var inventory := {}
var dimension : int = GLOBALS.DIMENSION.WITCH_CASTLE setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	emit_signal("dimension_changed")

var has_heart := false setget set_has_heart
func set_has_heart(value : bool) -> void:
	has_heart = value
	if has_heart:
		emit_signal("heart_acquired")

func reset():
	player_health = GLOBALS.MAX_PLAYER_HEALTH

	inventory.clear()
	for key in GLOBALS.ITEMS_DICT.keys():
		var value : Dictionary = GLOBALS.ITEMS_DICT[key]
		inventory[key] = value.get("initial_amount", 0)

	dimension = GLOBALS.DIMENSION.WITCH_CASTLE
	has_heart = false

func increase_player_health():
	self.player_health += 1

func decrease_player_health():
	self.player_health -= 1

func acquire_heart():
	self.has_heart = true

func get_item_amount(item_type : int) -> int:
	return inventory.get(item_type, 0)

func increase_item_amount(item_type : int):
	inventory[item_type] += 1
	emit_signal("item_amount_changed")

func decrease_item_amount(item_type : int):
	inventory[item_type] -= 1
	emit_signal("item_amount_changed")

func start_tutorial(args : Array):
	var type : String = args[0]

	emit_signal("tutorial_requested", type)
