extends Weapon

export(PackedScene) var projectile_scene: PackedScene = preload("res://weapon/projectile/BlunderbussProjectile.tscn")

export(float) var total_fire_angle_degrees: float = 30
onready var total_fire_angle_rad: float = deg2rad(total_fire_angle_degrees)

func initialise():
	pass

func fire(aimcast: RayCast2D, _player, is_press: bool):
	if is_press:
		spawn_projectile(aimcast.cast_to.normalized())

func spawn_projectile(direction: Vector2):
	var new_projectile = projectile_scene.instance()
	new_projectile.set_properties(damage, knockback_magnitude, direction)
	add_child(new_projectile)
	new_projectile.global_transform.origin = global_transform.origin
	new_projectile.launch()
