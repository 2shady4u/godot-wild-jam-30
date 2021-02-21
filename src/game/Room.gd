tool
class_name Room
extends YSort

const SCENE_PICKUP := preload("res://src/game/Pickup.tscn")
const SCENE_YELLOW_BRICK_TILE := preload("res://src/game/YellowBrickTile.tscn")
const SCENE_BOTTLE := preload("res://src/game/Bottle.tscn")
const SCENE_TARGET := preload("res://src/game/Target.tscn")

const SCENE_PUSHABLE_OBJECT := preload("res://src/game/PushableObject.tscn")
const SCENE_MONKEY := preload("res://src/game/Monkey.tscn")

var bottle_to_target_mapping := {}

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_room()

export(String) var id := ""
export(float) var camera_zoom := 1.0

var active_tilemap : TileMap
var player : Player

onready var _respawn_point := $RespawnPoint

onready var _emerald_city := $EmeraldCity
onready var _witch_castle := $WitchCastle

onready var _yellow_brick_tiles := $YellowBrickTiles
onready var _pickups := $Pickups
onready var _doors := $Doors
onready var _enemies := $Enemies
onready var _levers := $Levers
onready var _pressure_plates := $PressurePlates
onready var _pushable_objects := $PushableObjects

onready var _visibility_enabler := $VisibilityEnabler2D
onready var _interact_area := $InteractArea
onready var _navigation_2d := $Navigation2D

var _initial_room_layout := {
	"enemies": [],
	"pushable_objects": []
}
var _is_room_completed := false
var _room_completed_stream := preload("res://audio/sfx/room_complete.ogg")

signal player_entered_room

func _ready() -> void:
	if not Engine.editor_hint:
		var _error : int = _interact_area.connect("body_entered", self, "_on_body_entered")
		_error = _visibility_enabler.connect("screen_exited", self, "_on_screen_exited")

		for child in _pickups.get_children():
			_error = child.connect("picked_up", self, "_on_pickup_picked_up", [child])

		for child in _doors.get_children():
			_error = child.connect("opened", self, "_on_door_opened", [child])

		for child in _levers.get_children():
			_error = child.connect("toggled", self, "_on_lever_toggled")

		for child in _pressure_plates.get_children():
			_error = child.connect("pressed", self, "_on_pressure_plate_pressed")

		_initial_room_layout["pushable_objects"] = []
		for child in _pushable_objects.get_children():
			var pushable_object_dict := {
				"position" : child.position,
			}
			_initial_room_layout["pushable_objects"].append(pushable_object_dict)

		for child in _enemies.get_children():
			_error = child.connect("defeated", self, "_on_enemy_defeated", [child])
			if child is Witch:
				_error = child.connect("bottles_thrown", self, "_on_witch_bottles_thrown")
				_error = child.connect("summon", self, "_on_witch_summon")
				_error = child.connect("smashed", self, "_on_witch_smashed")
				_error = child.connect("smashed", self, "_on_witch_done_smashing")
			else:
				_error = child.connect("nav_path_requested", self, "_on_nav_path_requested", [child])

			if child is Monkey:
				var enemy_dict := {
					"position" : child.position,
				}
				_initial_room_layout["enemies"].append(enemy_dict)
	else:
		update_room()

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is Player:
		print("player entered me!")

		var room_settings : Dictionary = GLOBALS.ROOMS_DICT.get(id, {})
		var on_enter : Array = room_settings.get("on_enter", [])
		for reward in on_enter:
			var action : String = reward.get("action", "")
			if action in bindings:
				var args : Array = reward.get("args", [])
				var callback : FuncRef = bindings[action]
				callback.call_func(args)

		emit_signal("player_entered_room")

func _on_screen_exited() -> void:
	print("player exited me!")
	if not _is_room_completed:
		# reset the room!
		for child in _pushable_objects.get_children():
			_pushable_objects.remove_child(child)
			child.queue_free()
		for pushable_object_dict in _initial_room_layout["pushable_objects"]:
			var pushable_object := SCENE_PUSHABLE_OBJECT.instance()
			_pushable_objects.call_deferred("add_child", pushable_object)

			pushable_object.position = pushable_object_dict.position
			pushable_object.dimension = dimension

		for child in _enemies.get_children():
			if child is Monkey:
				_enemies.remove_child(child)
				child.queue_free()
		for enemy_dict in _initial_room_layout["enemies"]:
			var enemy := SCENE_MONKEY.instance()
			_enemies.call_deferred("add_child", enemy)

			var _error : int = enemy.connect("defeated", self, "_on_enemy_defeated", [enemy])
			_error = enemy.connect("nav_path_requested", self, "_on_nav_path_requested", [enemy])

			enemy.position = enemy_dict.position

func _on_dimension_changed() -> void:
	dimension = State.dimension
	update_room()

	match State.dimension:
		GLOBALS.DIMENSION.WITCH_CASTLE:
			_emerald_city.visible = false
			_witch_castle.visible = true
			active_tilemap = _witch_castle.get_node("TileMap")
		GLOBALS.DIMENSION.EMERALD_CITY:
			_emerald_city.visible = true
			_witch_castle.visible = false
			active_tilemap = _emerald_city.get_node("TileMap")

func update_room():
	match dimension:
		GLOBALS.DIMENSION.WITCH_CASTLE:
			$EmeraldCity.visible = false
			$WitchCastle.visible = true
			active_tilemap = $WitchCastle.get_node("TileMap")
		GLOBALS.DIMENSION.EMERALD_CITY:
			$EmeraldCity.visible = true
			$WitchCastle.visible = false
			active_tilemap = $EmeraldCity.get_node("TileMap")

	for child in $Doors.get_children():
		(child as Door).dimension = dimension
	for child in $Levers.get_children():
		(child as Lever).dimension = dimension
	for child in $PressurePlates.get_children():
		(child as PressurePlate).dimension = dimension
	for child in $PushableObjects.get_children():
		(child as PushableObject).dimension = dimension
	for child in $Enemies.get_children():
		if child is YellowBrickMonster:
			(child as YellowBrickMonster).dimension = dimension

func get_cell(player_position : Vector2) -> int:
	if active_tilemap:
		player_position -= active_tilemap.position
		player_position -= global_position
		# Take into account the Tilemap's scaling!
		player_position *= 2
		var map_position := active_tilemap.world_to_map(player_position)
		return active_tilemap.get_cellv(map_position)
	return -1

func _on_pickup_picked_up(pickup : Pickup) -> void:
	Flow.pick_up_pickup(pickup.type)

	# Delete the pickup!
	_pickups.remove_child(pickup)
	pickup.queue_free()

func _on_door_opened(door : Door) -> void:
	# Delete the door!
	_doors.remove_child(door)
	door.queue_free()

func _on_nav_path_requested(enemy : PhysicsBody2D) -> void:
	var enemy_position := enemy.position
	var player_position := player.global_position - position
	var nav_path : PoolVector2Array = _navigation_2d.get_simple_path(enemy_position, player_position)
	nav_path.remove(0)

	enemy.nav_path = nav_path

func _on_enemy_defeated(enemy : PhysicsBody2D) -> void:
	# Delete the enemy!
	_enemies.remove_child(enemy)
	enemy.queue_free()

	check_room_completion()

func _on_lever_toggled() -> void:
	check_room_completion()

	for lever in _levers.get_children():
		if not lever.active:
			return

	var room_settings : Dictionary = GLOBALS.ROOMS_DICT.get(id, {})
	var events : Dictionary = room_settings.get("events", {})
	var event : Array = events.get("all_levers_on", [])
	for reward in event:
		var action : String = reward.get("action", "")
		if action in bindings:
			var args : Array = reward.get("args", [])
			var callback : FuncRef = bindings[action]
			callback.call_func(args)

func _on_pressure_plate_pressed() -> void:
	check_room_completion()

func check_room_completion():
	print("checking completion condition!")
	if _is_room_completed:
		print("room already completed!")
		return

	var room_settings : Dictionary = GLOBALS.ROOMS_DICT.get(id, {})
	var conditions : Array = room_settings.get("conditions", [])
	for condition in conditions:
		match condition:
			"all_enemies_defeated":
				if not _enemies.get_children().empty():
					return
			"all_levers_on":
				for lever in _levers.get_children():
					if not lever.active:
						return
			"all_pressure_plates_down":
				for pressure_plate in _pressure_plates.get_children():
					if not pressure_plate.pressed:
						return
			_:
				return

	print("ROOM COMPLETED!")
	_is_room_completed = true
	AudioEngine.play_effect(_room_completed_stream)
	var rewards : Array = room_settings.get("rewards", [])
	_on_room_completed(rewards)

func _on_room_completed(rewards : Array):
	for lever in _levers.get_children():
		lever.locked = true

	for reward in rewards:
		var action : String = reward.get("action", "")
		if action in bindings:
			var args : Array = reward.get("args", [])
			var callback : FuncRef = bindings[action]
			callback.call_func(args)

	for door in _doors.get_children():
		if door.type == GLOBALS.DOOR_TYPE.ROOM_COMPLETION:
			door.open()

# WITCH BATTLE
func _on_witch_bottles_thrown(amount : int):
	for _i in range(amount):
		var random_coordinate = Vector2((randf() - 0.5) * 11 * 64, (randf() - 0.5) * 7 * 64)
		var bottle := SCENE_BOTTLE.instance()
		$Bottles.add_child(bottle)
		var target := SCENE_TARGET.instance()
		$Targets.add_child(target)
		var distance = 900 + randf() * 200
		bottle.position = random_coordinate + Vector2(0, - distance)
		bottle.set_distance(distance)
		var _error : int = bottle.connect("shattered", self, "_on_bottle_shattered", [bottle])
		target.position = random_coordinate
		bottle_to_target_mapping[bottle] = target

func _on_witch_smashed():
	for child in _yellow_brick_tiles.get_children():
		if (child as YellowBrickTile).cracked_level == 4:
			_yellow_brick_tiles.remove_child(child)
			child.queue_free()
		else:
			(child as YellowBrickTile).cracked_level += 1

func _on_witch_done_smashing() -> void:
	for child in _levers.get_children():
		(child as Lever).active = false
		(child as Lever).locked = false

func _on_bottle_shattered(bottle : Bottle) -> void:
	var target = bottle_to_target_mapping[bottle]
	target.shatter()
	AudioEngine.play_effect(preload("res://audio/sfx/potion_shatter.ogg"))
	if target.is_player_inside():
		print("Player is inside!")
		State.decrease_player_health()

# BINDINGS FOR ROOM COMPLETION!
# Probably also add the witch attacks here!?
var bindings := {
	"spawn_pickup": funcref(self, "spawn_pickup"),
	"spawn_yellow_brick_tile": funcref(self, "spawn_yellow_brick_tile"),
	"spawn_enemy": funcref(self, "spawn_enemy"),
	"game_completed": funcref(self, "game_completed"),
	"start_tutorial": funcref(State, "start_tutorial")
}

func spawn_pickup(args : Array) -> void:
	var type : int = args[0]
	var pickup : Pickup = SCENE_PICKUP.instance()
	pickup.type = type

	var _error := pickup.connect("picked_up", self, "_on_pickup_picked_up", [pickup])

	_pickups.call_deferred("add_child", pickup)

func spawn_enemy(args : Array) -> void:
	var enemy_position : Vector2 = args[0]
	var monkey : Monkey = SCENE_MONKEY.instance()
	monkey.position = enemy_position

	for child in _levers.get_children():
		(child as Lever).locked = true

	_enemies.call_deferred("add_child", monkey)

func spawn_yellow_brick_tile(args : Array) -> void:
	var tile_position : Vector2 = args[0]
	var yellow_brick_tile : YellowBrickTile = SCENE_YELLOW_BRICK_TILE.instance()
	yellow_brick_tile.position = tile_position

	for child in _levers.get_children():
		(child as Lever).locked = true

	_yellow_brick_tiles.call_deferred("add_child", yellow_brick_tile)

func game_completed(_args : Array) -> void:
	Flow.change_scene_to("outro")
