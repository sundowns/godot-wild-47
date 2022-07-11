extends Projectile

export(float) var base_speed: float = 600

var damage: float = 0
var knockback: float = 0
var linear_direction: Vector2 = Vector2.ZERO

func _on_impact(_body_rid, _body, _body_shape_index, _local_shape_index):
	._on_impact(_body_rid, _body, _body_shape_index, _local_shape_index)
	# TODO: Do some damage, spawn an explosion, etc
	expire()

func set_properties(_damage: float, _knockback: float, direction: Vector2):
	damage = _damage
	knockback = _knockback
	linear_direction = direction

func launch():
	apply_central_impulse(linear_direction * base_speed)
	sprite.look_at(global_transform.origin +  linear_direction)
	sprite.rotation += PI/2

func handle_movement_extrapolation():
	sprite.transform.origin = linear_direction * base_speed * ((1.0 / float(Engine.iterations_per_second)) * Engine.get_physics_interpolation_fraction()) * Engine.time_scale
