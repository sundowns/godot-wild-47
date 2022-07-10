extends Node2D
class_name Weapon

export(float) var damage: float
export(float) var knockback_magnitude: float
export(bool) var has_alternate_fire: bool = false
export(float) var recoil_magnitude: float = 1.0

onready var sprite = $Sprite

var is_ready := true

signal alternate_fire_pressed
signal alternate_fire_released

func initialise():
	pass

func gun_fired():
	is_ready = false

func hide():
	sprite.visible = false
	
func show():
	sprite.visible = true
	
func alternate_fire(_aimcast: RayCast2D, _player: KinematicBody2D, is_press: bool):
	if is_press:
		emit_signal("alternate_fire_pressed")
	else:
		emit_signal("alternate_fire_released")

#func _process(delta):
#	look_at(get_global_mouse_position())

# Just here for an overridable function signature
func fire(_aimcast: RayCast2D, _player: KinematicBody2D, _is_press: bool):
	pass
