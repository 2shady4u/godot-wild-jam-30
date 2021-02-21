tool
class_name YellowBrickTile
extends Area2D

export(int) var cracked_level : int setget set_cracked_level
func set_cracked_level(value : int):
	cracked_level = int(clamp(value, 0, 4))
	if is_inside_tree():
		update_yellow_brick_tile()

func update_yellow_brick_tile():
	match cracked_level:
		0:
			$Cracked.texture = null
		1:
			$Cracked.texture = preload("res://resources/cracked_1_atlastexture.tres")
		2:
			$Cracked.texture = preload("res://resources/cracked_2_atlastexture.tres")
		3:
			$Cracked.texture = preload("res://resources/cracked_3_atlastexture.tres")
		4:
			$Cracked.texture = preload("res://resources/cracked_4_atlastexture.tres")

	if cracked_level != 0:
		AudioEngine.play_effect(preload("res://audio/sfx/tile_crack.ogg"))
