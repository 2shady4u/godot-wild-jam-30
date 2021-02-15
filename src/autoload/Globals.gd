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
	"oil_can": {
		"texture": preload('res://resources/oil_can_atlastexture.tres'),
		"actions": ["increase_health"]
	},
	"heart": {
		"texture": preload('res://resources/heart_atlastexture.tres'),
		"actions": ["acquire_heart"]
	}
}

const LEVERS_DICT := {
	true: {
		"texture": preload('res://resources/lever_on_atlastexture.tres'),
	},
	false: {
		"texture": preload('res://resources/lever_off_atlastexture.tres'),
	}
}

enum DIRECTION {TOP, BOTTOM, LEFT, RIGHT}
enum DOOR_TYPE {LOCKED, BOSS, ROOM_COMPLETION}

const DOORS_DICT := {
	DOOR_TYPE.LOCKED: {
		"texture": preload('res://resources/door_locked_emerald_city_atlastexture.tres'),
	},
	DOOR_TYPE.BOSS: {
		"texture": preload('res://resources/lever_on_atlastexture.tres'),
	},
	DOOR_TYPE.ROOM_COMPLETION: {
		"texture": preload('res://resources/door_room_completion_emerald_city_atlastexture.tres'),
	},
}

const ROOMS_DICT := {
	"start": {
		"condition": "all_levers_on",
		"rewards": [{
			"action": "spawn_pickup",
			"args": ["oil_can"]
		}]
	},
	"first_battle": {
		"rewards": [{
			"action": "spawn_pickup",
			"args": ["oil_can"]
		}]
	},
	"acquire_heart": {
		"rewards": [{
			"action": "spawn_pickup",
			"args": ["oil_can"]
		}]
	}
}
