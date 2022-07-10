extends Node2D
class_name Hand

signal hand_position_updated

export(float) var max_distance_from_player: float = 16.0
export(float) var hand_movement_deadzone: float = 1.0

onready var weapon_anchor: Node2D = $WeaponAnchor

func update_hand_position(mouse_global_position: Vector2):
	var parent_position = get_parent().global_transform.origin
	var to_mouse = (mouse_global_position - parent_position)
	if (to_mouse.length() >= hand_movement_deadzone):
		position = to_mouse.normalized() *  min(to_mouse.length(), max_distance_from_player)
		emit_signal("hand_position_updated")

func _input(event):
	if event is InputEventMouseMotion:
		update_hand_position(get_global_mouse_position())

func get_weapons() -> Array:
	var held_weapons = []
	for child in weapon_anchor.get_children():
		if child is Weapon:
			held_weapons.append(child)
	return held_weapons
