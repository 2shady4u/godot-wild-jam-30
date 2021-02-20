tool
class_name Room
extends YSort

const SCENE_PICKUP := preload("res://src/game/Pickup.tscn")

export(GLOBALS.DIMENSION) var dimension : int setget set_dimension
func set_dimension(value : int) -> void:
	dimension = value
	if is_inside_tree():
		update_room()

export(String) var id := ""
export(float) var camera_zoom := 1.0

var active_tilemap : TileMap
var player : Player

onready var _emerald_city := $EmeraldCity
onready var _witch_castle := $WitchCastle

onready var _pickups := $Pickups
onready var _doors := $Doors
onready var _enemies := $Enemies
onready var _levers := $Levers
onready var _pressure_plates := $PressurePlates
onready var _pushable_objects := $PushableObjects

onready var _interact_area := $InteractArea
onready var _navigation_2d := $Navigation2D

var _initial_room_layout := {
	"levers": []
}
var _is_room_completed := false
var _room_completed_stream := preload("res://audio/sfx/room_complete.ogg")

signal player_entered_room

func _ready() -> void:
	if not Engine.editor_hint:
		var _error : int = _interact_area.connect("body_entered", self, "_on_body_entered")

		for child in _pickups.get_children():
			_error = child.connect("picked_up", self, "_on_pickup_picked_up", [child])

		for child in _doors.get_children():
			_error = child.connect("opened", self, "_on_door_opened", [child])

		for child in _levers.get_children():
			_error = child.connect("toggled", self, "_on_lever_toggled")

		for child in _pressure_plates.get_children():
			_error = child.connect("pressed", self, "_on_pressure_plate_pressed")

		for child in _enemies.get_children():
			_error = child.connect("nav_path_requested", self, "_on_nav_path_requested", [child])
			_error = child.connect("defeated", self, "_on_enemy_defeated", [child])

	else:
		update_room()

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is Player:
		print("player entered me!")
		emit_signal("player_entered_room")

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
	var enemy_position := enemy.global_position
	var player_position := player.global_position
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

func _on_pressure_plate_pressed() -> void:
	check_room_completion()

func check_room_completion():
	print("checking completion condition!")
	if _is_room_completed:
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

# BINDINGS FOR ROOM COMPLETION!
# Probably also add the witch attacks here!
var bindings := {
	"spawn_pickup": funcref(self, "spawn_pickup")
}

func spawn_pickup(args : Array) -> void:
	var type : int = args[0]
	var pickup : Pickup = SCENE_PICKUP.instance()
	pickup.type = type

	var _error := pickup.connect("picked_up", self, "_on_pickup_picked_up", [pickup])

	_pickups.call_deferred("add_child", pickup)
