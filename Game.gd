extends Node2D

export(PackedScene) var level_to_load: PackedScene = preload("res://world/levels/testing1.tscn")
export(PackedScene) var player_scene: PackedScene = preload("res://player/Player.tscn")

onready var entities: Node = $Entities
onready var level_anchor: Position2D = $LevelAnchor

var current_level = null
var player = null

func _ready():
	current_level = level_to_load.instance()
	level_anchor.add_child(current_level)
	player = spawn_player(current_level.get_player_spawn_position())

func spawn_player(spawn_position: Vector2) -> Player:
	var new_player = player_scene.instance()
	entities.add_child(new_player)
	new_player.spawn_at(spawn_position)
	return new_player
