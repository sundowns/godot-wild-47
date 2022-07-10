extends Node2D

export(float) var max_distance_from_player: float = 16.0

func update_hand_position(mouse_global_position: Vector2):
	var parent_position = get_parent().global_transform.origin
	var to_mouse = (mouse_global_position - parent_position)
	position = to_mouse.normalized() *  min(to_mouse.length(), max_distance_from_player)
#	print(parent_position, mouse_global_position, to_mouse)
#	pass

func _input(event):
	if event is InputEventMouseMotion:
		update_hand_position(get_global_mouse_position())
