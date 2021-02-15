extends Control

const SCENE_HEALTH_RECT := preload("res://src/game/UI/game_overlay/HealthRect.tscn")
const SCENE_ITEM_HBOX := preload("res://src/game/UI/game_overlay/ItemHBox.tscn")

onready var _health_hbox := $HB/Control/MC/HB/HealthHBox
onready var _inventory_vbox := $HB/Control/InventoryMC/VB

func _ready():
	var _error := State.connect("player_health_changed", self, "_on_player_health_changed")
	_error = State.connect("item_amount_changed", self, "_on_item_amount_changed")

	for child in _health_hbox.get_children():
		_health_hbox.remove_child(child)
		child.queue_free()

	for _i in range(Globals.MAX_PLAYER_HEALTH):
		var health_rect := SCENE_HEALTH_RECT.instance()
		_health_hbox.add_child(health_rect)

	for child in _inventory_vbox.get_children():
		_inventory_vbox.remove_child(child)
		child.queue_free()

	# Add all the items!
	for key in GLOBALS.ITEMS_DICT.keys():
		var item_hbox := SCENE_ITEM_HBOX.instance()
		item_hbox.id = key

		_inventory_vbox.add_child(item_hbox)

	update_overlay()

func _on_player_health_changed():
	update_overlay()

func _on_item_amount_changed():
	# Don't care about which item amount gets changed, just update them all!!!
	update_overlay()

func update_overlay():
	var i := 0
	for child in _health_hbox.get_children():
		if State.player_health > i:
			child.active = true
		else:
			child.active = false
		i += 1

	for child in _inventory_vbox.get_children():
		var item_id : String = child.id
		var amount : int = State.get_item_amount(item_id)
		child.amount = amount
