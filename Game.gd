extends Node2D

export(PackedScene) var level_to_load: PackedScene = preload("res://world/levels/testing1.tscn")

onready var world_anchor: Position2D = $WorldAnchor

func _ready():
	world_anchor.add_child(level_to_load.instance())
