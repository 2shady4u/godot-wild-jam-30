tool
extends HBoxContainer

export(String) var id := ""

export(Texture) var texture := load("res://icon.png") setget set_texture
func set_texture(value : Texture) -> void:
	texture = value
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
	$TextureRect.texture = texture
