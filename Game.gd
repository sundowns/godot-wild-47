extends Node2D

export(PackedScene) var level_to_load: PackedScene = preload("res://world/levels/testing1.tscn")

func _ready():
	add_child(level_to_load.instance())
