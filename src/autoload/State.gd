extends Node

signal player_health_changed
signal item_amount_changed

var player_health := Globals.MAX_HEALTH setget set_player_health
func set_player_health(value : int) -> void:
	player_health = int(clamp(value, 0, Globals.MAX_HEALTH))
	if player_health == 0:
		Flow.change_scene_to("defeat")
	else:
		emit_signal("player_health_changed")

var inventory := {}

func reset():
	player_health = Globals.MAX_HEALTH

	inventory.clear()
	for key in Globals.ITEMS_DICT.keys():
		var value : Dictionary = Globals.ITEMS_DICT[key]
		inventory[key] = value.get("initial_amount", 0)

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
