extends Control

enum STATUS {NOT_STARTED, IN_PROGRESS, COMPLETED}

const INTERACT_TUTORIAL_HINT := 'Press "F" to interact with objects'
const ATTACK_TUTORIAL_HINT := 'Press "E" to attack'
const TOGGLE_HEART_TUTORIAL_HINT := 'Press "H" to activate heart'

const SCENE_HEALTH_RECT := preload("res://src/game/UI/game_overlay/HealthRect.tscn")
const SCENE_ITEM_HBOX := preload("res://src/game/UI/game_overlay/ItemHBox.tscn")

onready var _heart_rect := $HB/Left/MC/VB/HeartRect
onready var _health_hbox := $HB/Left/MC/VB/HealthHBox
onready var _inventory_vbox := $HB/Right/InventoryMC/VB
onready var _hint_label := $HB/Control/MC/VB/HintLabel

var _interact_tutorial_status : int = STATUS.NOT_STARTED
var _attack_tutorial_status : int = STATUS.NOT_STARTED
var _toggle_heart_tutorial_status : int = STATUS.NOT_STARTED

func _ready() -> void:
	var _error := State.connect("player_health_changed", self, "_on_player_health_changed")
	_error = State.connect("item_amount_changed", self, "_on_item_amount_changed")
	_error = State.connect("heart_acquired", self, "_on_heart_acquired")
	_error = State.connect("dimension_changed", self, "_on_dimension_changed")
	_error = State.connect("tutorial_requested", self, "_on_tutorial_requested")

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
		item_hbox.type = key

		_inventory_vbox.add_child(item_hbox)

	_hint_label.visible = false
	if State.has_heart:
		_toggle_heart_tutorial_status = STATUS.COMPLETED
	else:
		_toggle_heart_tutorial_status = STATUS.NOT_STARTED

	set_process_input(false)
	update_overlay()

func _on_player_health_changed() -> void:
	update_overlay()

func _on_item_amount_changed() -> void:
	# Don't care about which item amount gets changed, just update them all!!!
	update_overlay()

func _on_heart_acquired() -> void:
	start_tutorial("toggle_heart")
	update_overlay()

func _on_dimension_changed() -> void:
	update_overlay()

func _on_tutorial_requested(type : String) -> void:
	start_tutorial(type)

func start_tutorial(type : String) -> void:
	match type:
		"attack":
			match _attack_tutorial_status:
				STATUS.NOT_STARTED:
					_attack_tutorial_status = STATUS.IN_PROGRESS
					_hint_label.text = ATTACK_TUTORIAL_HINT
				_:
					return
		"interact":
			match _interact_tutorial_status:
				STATUS.NOT_STARTED:
					_interact_tutorial_status = STATUS.IN_PROGRESS
					_hint_label.text = INTERACT_TUTORIAL_HINT
				_:
					return
		"toggle_heart":
			match _toggle_heart_tutorial_status:
				STATUS.NOT_STARTED:
					_toggle_heart_tutorial_status = STATUS.IN_PROGRESS
					_hint_label.text = TOGGLE_HEART_TUTORIAL_HINT
				_:
					return

	_hint_label.visible = true
	set_process_input(true)
	update_overlay()

func end_tutorial():
	_hint_label.visible = false
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("attack"):
		if _attack_tutorial_status == STATUS.IN_PROGRESS:
			_attack_tutorial_status = STATUS.COMPLETED
			end_tutorial()
	elif event.is_action_pressed("interact"):
		if _interact_tutorial_status == STATUS.IN_PROGRESS:
			_interact_tutorial_status = STATUS.COMPLETED
			end_tutorial()
	elif event.is_action_pressed("toggle_heart"):
		if _toggle_heart_tutorial_status == STATUS.IN_PROGRESS:
			_toggle_heart_tutorial_status = STATUS.COMPLETED
			end_tutorial()

func update_overlay() -> void:
	if State.has_heart:
		_heart_rect.visible = true
		match State.dimension:
			GLOBALS.DIMENSION.WITCH_CASTLE:
				_heart_rect.modulate = Color( 0.25, 0.25, 0.25, 1 )
			GLOBALS.DIMENSION.EMERALD_CITY:
				_heart_rect.modulate = Color.white
	else:
		_heart_rect.visible = false

	var i := 0
	for child in _health_hbox.get_children():
		if State.player_health > i:
			child.active = true
		else:
			child.active = false
		i += 1

	for child in _inventory_vbox.get_children():
		var item_type : int = child.type
		var amount : int = State.get_item_amount(item_type)
		child.amount = amount
