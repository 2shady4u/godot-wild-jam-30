class_name GLOBALS
extends Node

const MAX_HEALTH := 3
const ITEMS_DICT := {
	"key": {
		"initial_amount": 2,
		"item_texture": preload('res://icon.png')
	},
	"boss_key": {
		"initial_amount": 1,
		"item_texture": preload('res://icon.png')
	}
}

const PICKUPS_DICT := {
	"key": {
		"pickup_texture": preload('res://icon.png'),
		"item_id": "key"
	},
	"boss_key": {
		"pickup_texture": preload('res://icon.png'),
		"item_id": "boss_key"
	},
	"bandage": {
		"pickup_texture": preload('res://icon.png'),
		"actions": ["increase_health"]
	}
}
