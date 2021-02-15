class_name GLOBALS
extends Node

enum DIRECTION {TOP, BOTTOM, LEFT, RIGHT}
enum DOOR_TYPE {LOCKED, BOSS, ROOM_COMPLETION}
enum DIMENSION {EMERALD_CITY, WITCH_CASTLE}

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
	DIMENSION.EMERALD_CITY: {
		true: {
			"texture": preload('res://resources/lever_on_emerald_city_atlastexture.tres'),
		},
		false: {
			"texture": preload('res://resources/lever_off_emerald_city_atlastexture.tres'),
		}
	},
	DIMENSION.WITCH_CASTLE: {
		true: {
			"texture": preload('res://resources/lever_on_witch_castle_atlastexture.tres'),
		},
		false: {
			"texture": preload('res://resources/lever_off_witch_castle_atlastexture.tres'),
		}
	}
}

const PRESSURE_PLATES_DICT := {
	DIMENSION.EMERALD_CITY: {
		true: {
			"texture": preload('res://resources/pressure_plate_down_emerald_city_atlastexture.tres'),
		},
		false: {
			"texture": preload('res://resources/pressure_plate_up_emerald_city_atlastexture.tres'),
		}
	},
	DIMENSION.WITCH_CASTLE: {
		true: {
			"texture": preload('res://resources/pressure_plate_down_witch_castle_atlastexture.tres'),
		},
		false: {
			"texture": preload('res://resources/pressure_plate_up_witch_castle_atlastexture.tres'),
		}
	},
}

const PUSHABLE_OBJECTS_DICT := {
	DIMENSION.EMERALD_CITY: {
	"texture": preload('res://resources/pushable_object_emerald_city_atlastexture.tres'),
	},
	DIMENSION.WITCH_CASTLE: {
	"texture": preload('res://resources/pushable_object_witch_castle_atlastexture.tres')
	}
}

const DOORS_DICT := {
	DIMENSION.EMERALD_CITY: {
		DOOR_TYPE.LOCKED: {
			"texture": preload('res://resources/door_locked_emerald_city_atlastexture.tres'),
		},
		DOOR_TYPE.BOSS: {
			"texture": preload('res://resources/door_locked_emerald_city_atlastexture.tres'),
		},
		DOOR_TYPE.ROOM_COMPLETION: {
			"texture": preload('res://resources/door_room_completion_emerald_city_atlastexture.tres'),
		}
	},
	DIMENSION.WITCH_CASTLE: {
		DOOR_TYPE.LOCKED: {
			"texture": preload('res://resources/door_locked_witch_castle_atlastexture.tres'),
		},
		DOOR_TYPE.BOSS: {
			"texture": preload('res://resources/door_locked_witch_castle_atlastexture.tres'),
		},
		DOOR_TYPE.ROOM_COMPLETION: {
			"texture": preload('res://resources/door_room_completion_witch_castle_atlastexture.tres'),
		}
	}
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
