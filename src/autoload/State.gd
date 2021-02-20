extends Node

signal player_health_changed
signal item_amount_changed
signal heart_acquired

var player_health := GLOBALS.MAX_PLAYER_HEALTH setget set_player_health
func set_player_health(value : int) -> void:
	player_health = int(clamp(value, 0, GLOBALS.MAX_PLAYER_HEALTH))
	if player_health == 0:
		Flow.change_scene_to("defeat")
	else:
		emit_signal("player_health_changed")

var inventory := {}
var dimension : int = GLOBALS.DIMENSION.WITCH_CASTLE

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

func get_item_amount(item_id : String) -> int:
	return inventory.get(item_id, 0)

func increase_item_amount(item_id : String):
	inventory[item_id] += 1
	emit_signal("item_amount_changed")

func decrease_item_amount(item_id : String):
	inventory[item_id] -= 1
	emit_signal("item_amount_changed")
