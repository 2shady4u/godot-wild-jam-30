class_name GLOBALS
extends Node

enum DIRECTION {TOP, BOTTOM, LEFT, RIGHT}
enum DOOR_TYPE {LOCKED, BOSS, ROOM_COMPLETION}
enum DIMENSION {EMERALD_CITY, WITCH_CASTLE}

enum AUDIO_BUS {MASTER, MUSIC, SFX}

const MONKEY_MOVE_SPEED := 40

const MAX_MONKEY_HEALTH := 2
const MAX_PLAYER_HEALTH := 3

const PLAYER_ANIMATIONS_DICT := {
	false: {
		DIRECTION.TOP: {
			"animation": "idle_up",
			"offset": Vector2(-4, -35)
		},
		DIRECTION.BOTTOM: {
			"animation": "idle_down",
			"offset": Vector2(-5, -40)
		},
		DIRECTION.LEFT: {
			"animation": "idle_right",
			"flip_h": true,
			"offset": Vector2(0, -38)
		},
		DIRECTION.RIGHT: {
			"animation": "idle_right",
			"offset": Vector2(0, -38)
		},
	},
	true: {
		DIRECTION.TOP: {
			"animation": "walk_up",
			"offset": Vector2(-4, -35)
		},
		DIRECTION.BOTTOM: {
			"animation": "walk_down",
			"offset": Vector2(-5, -40)
		},
		DIRECTION.LEFT: {
			"animation": "walk_right",
			"flip_h": true,
			"offset": Vector2(0, -38)
		},
		DIRECTION.RIGHT: {
			"animation": "walk_right",
			"offset": Vector2(0, -38)
		}
	}
}

const PLAYER_ATTACK_ANIMATIONS_DICT := {
	DIRECTION.TOP: {
		"animation": "attack_up",
		"offset": Vector2(-4, -35)
	},
	DIRECTION.BOTTOM: {
		"animation": "attack_down",
		"offset": Vector2(-5, -40)
	},
	DIRECTION.LEFT: {
		"animation": "attack_right",
		"flip_h": true,
		"offset": Vector2(0, -38)
	},
	DIRECTION.RIGHT: {
		"animation": "attack_right",
		"offset": Vector2(0, -38)
	},
}

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
		"item_id": "key",
		"stream": preload("res://audio/sfx/pickups/key_jingle.ogg")
	},
	"boss_key": {
		"texture": preload('res://resources/boss_key_atlastexture_multi.tres'),
		"item_id": "boss_key",
		"hframes": 2,
		"animation": preload("res://resources/boss_key_anim.tres"),
		"stream": preload("res://audio/sfx/pickups/boss_key_jingle.ogg")
	},
	"oil_can": {
		"texture": preload('res://resources/oil_can_atlastexture.tres'),
		"actions": ["increase_health"],
		"stream": preload("res://audio/sfx/pickups/oil_can.ogg")
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
			"offset": Vector2(0, -40)
		},
		false: {
			"texture": preload('res://resources/lever_off_emerald_city_atlastexture.tres'),
			"offset": Vector2(0, -40)
		}
	},
	DIMENSION.WITCH_CASTLE: {
		true: {
			"texture": preload('res://resources/lever_on_witch_castle_atlastexture.tres'),
			"offset": Vector2(0, -26)
		},
		false: {
			"texture": preload('res://resources/lever_off_witch_castle_atlastexture.tres'),
			"offset": Vector2(0, -26)
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
		"offset": Vector2(0, -26)
	},
	DIMENSION.WITCH_CASTLE: {
		"texture": preload('res://resources/pushable_object_witch_castle_atlastexture.tres'),
		"offset": Vector2(7, -22)
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
