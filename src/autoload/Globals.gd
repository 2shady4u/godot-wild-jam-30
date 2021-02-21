class_name GLOBALS
extends Node

enum DIRECTION {TOP, BOTTOM, LEFT, RIGHT}
enum DIMENSION {EMERALD_CITY, WITCH_CASTLE}
enum AUDIO_BUS {MASTER, MUSIC, SFX}

enum DOOR_TYPE {LOCKED, BOSS, ROOM_COMPLETION, WALL}
enum PICKUP_TYPE {KEY, BOSS_KEY, OIL_CAN, HEART}
enum ITEM_TYPE {KEY, BOSS_KEY}

const MONKEY_MOVE_SPEED := 40
const PLAYER_MOVE_SPEED := 200

const MAX_MONKEY_HEALTH := 2
const MAX_PLAYER_HEALTH := 3
const MAX_WITCH_HEALTH := 3

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

const MONKEY_ANIMATIONS_DICT := {
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
	},
}

const YELLOW_BRICK_MONSTER_ANIMATIONS_DICT := {
	DIMENSION.EMERALD_CITY: {
		DIRECTION.TOP: {
			"animation": "idle"
		},
		DIRECTION.BOTTOM: {
			"animation": "idle"
		},
		DIRECTION.LEFT: {
			"animation": "idle"
		},
		DIRECTION.RIGHT: {
			"animation": "idle"
		}
	},
	DIMENSION.WITCH_CASTLE: {
		DIRECTION.TOP: {
			"animation": "up"
		},
		DIRECTION.BOTTOM: {
			"animation": "down"
		},
		DIRECTION.LEFT: {
			"animation": "left"
		},
		DIRECTION.RIGHT: {
			"animation": "right"
		}
	}
}

const MONKEY_ATTACK_ANIMATIONS_DICT := {
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
	ITEM_TYPE.KEY: {
		"initial_amount": 0,
		"texture": preload('res://resources/key_atlastexture.tres'),
	},
	ITEM_TYPE.BOSS_KEY: {
		"initial_amount": 0,
		"texture": preload('res://resources/boss_key_atlastexture.tres')
	}
}

const PICKUPS_DICT := {
	PICKUP_TYPE.KEY: {
		"texture": preload('res://resources/key_atlastexture.tres'),
		"item_type": ITEM_TYPE.KEY,
		"stream": preload("res://audio/sfx/pickups/key_jingle.ogg")
	},
	PICKUP_TYPE.BOSS_KEY:  {
		"texture": preload('res://resources/boss_key_atlastexture_multi.tres'),
		"item_type": ITEM_TYPE.BOSS_KEY,
		"hframes": 2,
		"animation": preload("res://resources/boss_key_anim.tres"),
		"stream": preload("res://audio/sfx/pickups/boss_key_jingle.ogg")
	},
	PICKUP_TYPE.OIL_CAN:  {
		"texture": preload('res://resources/oil_can_atlastexture.tres'),
		"actions": ["increase_health"],
		"stream": preload("res://audio/sfx/pickups/oil_can.ogg")
	},
	PICKUP_TYPE.HEART:  {
		"texture": preload('res://resources/heart_atlastexture.tres'),
		"actions": ["acquire_heart"],
		"stream": preload("res://audio/sfx/pickups/heart_beat_2.ogg")
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
		},
		DOOR_TYPE.WALL: {
			"texture": preload('res://resources/door_wall_emerald_city_atlastexture.tres'),
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
		},
		DOOR_TYPE.WALL: {
			"texture": preload('res://resources/door_wall_witch_castle_atlastexture.tres'),
		}
	}
}

const ROOMS_DICT := {
	"start": {
		"conditions": ["all_levers_on", "all_pressure_plates_down"],
		"rewards": [{
			"action": "spawn_pickup",
			"args": [PICKUP_TYPE.KEY]
		}]
	},
	"first_void": {
		"on_enter": [{
			"action": "start_tutorial",
			"args": ["interact"]
		}],
		"conditions": ["all_levers_on", "all_pressure_plates_down"],
	},
	"first_battle": {
		"on_enter": [{
			"action": "start_tutorial",
			"args": ["attack"]
		}],
		"conditions": ["all_enemies_defeated"],
		"rewards": [{
			"action": "spawn_pickup",
			"args": [PICKUP_TYPE.KEY]
		}]
	},
	"acquire_heart": {
		"rewards": [{
			"action": "spawn_pickup",
			"args": [PICKUP_TYPE.KEY]
		}]
	},
	"floating_platforms": {
		"conditions": ["all_levers_on"],
		"rewards": [{
			"action": "spawn_pickup",
			"args": [PICKUP_TYPE.KEY]
		}]
	},
	"before_boss_room": {
		"conditions": ["all_enemies_defeated"],
		"rewards": [{
			"action": "spawn_pickup",
			"args": [PICKUP_TYPE.OIL_CAN]
		}]
	},
	"boss_room": {
		"conditions": ["all_enemies_defeated"],
		"rewards": [{
			"action": "game_completed",
			"args": []
		}],
		"events": {
			"all_levers_on": [{
				"action": "spawn_yellow_brick_tile",
				"args": [Vector2(0, -64)]
			}]
		}
	},
	"acquire_boss_key": {
		"conditions": ["all_levers_on"],
	}
}
