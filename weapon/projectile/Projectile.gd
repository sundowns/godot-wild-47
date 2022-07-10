extends RigidBody2D
class_name Projectile

var owner_id: int

export(PackedScene) var impact_scene: PackedScene

onready var expiry_timer: Timer = $ExpiryTimer
export(float) var time_to_live: float = 8
onready var sprite: Sprite = $Sprite

func _ready():
	set_as_toplevel(true)
	expiry_timer.start(time_to_live)

func set_source(_owner_id: int):
	owner_id = _owner_id

func _on_impact(_body_rid, _body, _body_shape_index, _local_shape_index):
	if impact_scene:
		var new_impact = impact_scene.instance()
		LevelStateDependencies.get("Effects").add_child(new_impact)
		new_impact.global_transform.origin = global_transform.origin

func expire():
	queue_free()

func _on_ExpiryTimer_timeout():
	expire()

func _process(_delta):
	handle_movement_extrapolation()

# Extrapolate the player's position in space between physics frames to smooth motion on framerates higher than the physics tickrate
func handle_movement_extrapolation():
	pass
