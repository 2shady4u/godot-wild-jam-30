tool
extends HBoxContainer

export(GLOBALS.ITEM_TYPE) var type : int setget set_type
func set_type(value : int) -> void:
	type = value
	if is_inside_tree():
		update_item_hbox()

export(int) var amount := 0 setget set_amount
func set_amount(value : int) -> void:
	amount = value
	if is_inside_tree():
		update_item_hbox()

func _ready():
	update_item_hbox()

func update_item_hbox():
	$AmountLabel.text = str(amount)

	var item_settings : Dictionary = GLOBALS.ITEMS_DICT.get(type, {})

	var texture : Texture = item_settings.get("texture", preload("res://icon.png"))
	$TextureRect.texture = texture
