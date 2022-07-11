extends Weapon

export(PackedScene) var projectile_scene: PackedScene = preload("res://weapon/projectile/BlunderbussProjectile.tscn")

onready var muzzle: Position2D = $Muzzle
onready var animation_player: AnimationPlayer = $AnimationPlayer

export(float) var total_firing_angle_degrees: float = 20
onready var total_firing_angle_radians: float = deg2rad(total_firing_angle_degrees)
export(float) var projectile_count: int = 4


func initialise(hand):
	.initialise(hand)

func fire(aimcast: RayCast2D, player, is_press: bool):
	if is_press and is_ready:
		.fire(aimcast, player, is_press)
		var angle_interval_radians = total_firing_angle_radians / projectile_count
		var aim_direction = aimcast.cast_to.normalized()
		for number in range(projectile_count):
			var rotated_direction = aim_direction.rotated((-total_firing_angle_radians/2) + angle_interval_radians/2 +  (angle_interval_radians * number))
			spawn_projectile(rotated_direction)
		player.push(-aim_direction * recoil_magnitude)
		animation_player.play("Fire")

func spawn_projectile(direction: Vector2):
	var new_projectile = projectile_scene.instance()
	new_projectile.set_properties(damage, knockback_magnitude, direction)
	add_child(new_projectile)
	new_projectile.global_transform.origin = muzzle.global_transform.origin
	new_projectile.launch()

