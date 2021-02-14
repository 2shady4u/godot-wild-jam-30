class_name GLOBALS
extends Node

const MONKEY_MOVE_SPEED := 40

const MAX_MONKEY_HEALTH := 2
const MAX_PLAYER_HEALTH := 3
const ITEMS_DICT := {
	"key": {
		"initial_amount": 1,
		"texture": preload('res://resources/key_atlastexture.tres'),
	},
	"boss_key": {
		"initial_amount": 1,
		"texture": preload('res://resources/boss_key_atlastexture.tres')
	}
}

const PICKUPS_DICT := {
	"key": {
		"texture": preload('res://resources/key_atlastexture.tres'),
		"item_id": "key"
	},
	"boss_key": {
		"texture": preload('res://resources/boss_key_atlastexture_multi.tres'),
		"item_id": "boss_key",
		"hframes": 2,
		"animation": preload("res://resources/boss_key_anim.tres")
	},
	"bandage": {
		"texture": preload('res://resources/bandage_atlastexture.tres'),
		"actions": ["increase_health"]
	},
	"heart": {
		"texture": preload('res://resources/heart_atlastexture.tres'),
		"actions": ["acquire_heart"]
	}
}

const ROOMS_DICT := {
	"start": {
		"on_completion": [{
			"action": "spawn_pickup",
			"args": ["bandage"]
		}]
	},
	"first_battle": {
		"on_completion": [{
			"action": "spawn_pickup",
			"args": ["bandage"]
		}]
	},
	"acquire_heart": {
		"on_completion": [{
			"action": "spawn_pickup",
			"args": ["bandage"]
		}]
	}
}
