extends Node2D

onready var player_spawn_point: Position2D = $PlayerSpawnPoint

func get_player_spawn_position() -> Vector2:
	return player_spawn_point.global_transform.origin
