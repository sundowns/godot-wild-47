extends KinematicBody2D
class_name Entity

var knockback := Vector2.ZERO
export(float) var knockback_drag: float = 150.0
export(float) var max_concurrent_knockback_magnitude: float = 500.0

# TODO: Extrapolate kb

func apply_knockback_drag(delta: float):
	if knockback.length() > 0:
		knockback = knockback.move_toward(Vector2.ZERO, delta * knockback_drag)

func push(force: Vector2):
	knockback += force
	if knockback.length() > max_concurrent_knockback_magnitude:
		knockback = knockback.normalized() * max_concurrent_knockback_magnitude
