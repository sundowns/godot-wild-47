extends Entity
class_name Player

var velocity: Vector2 = Vector2.ZERO
var unextrapolated_physics_position: Vector2 = Vector2.ZERO

export(float) var acceleration: float = 80 # per physics tick
export(float) var max_speed: float = 450
export(float) var ground_friction: float = 15.0 # per physics tick

onready var hand: Hand = $Hand
onready var head = $Head
onready var body_sprite: Sprite = $BodySprite

var pickupable_weapon: WeakRef = null

const aimcast_length: int = 10000
onready var aimcast: RayCast2D = $AimCast

func _input(event):
	if event.is_action("fire"):
		fire_weapon(event.is_pressed())
	if event.is_action("alt_fire"):
		alt_fire_weapon(event.is_pressed())
	if event.is_action("pickup"):
		attempt_weapon_pickup()

func _physics_process(delta):
	head.look_at(get_global_mouse_position())
	# Reset position to last physics frame before applying movement
	global_transform.origin = unextrapolated_physics_position
	apply_acceleration()
	velocity = velocity.normalized() * min(velocity.length(), max_speed)
	apply_friction()
	apply_velocity(delta)
	# Store end-of-physics frame position (for post-extrapolation recovery)
	unextrapolated_physics_position = global_transform.origin

func _process(_delta):
	handle_movement_extrapolation()

func apply_acceleration():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction += Vector2.UP
	elif Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT
	
	velocity += direction.normalized() * acceleration

func apply_friction(): 
	velocity = velocity.move_toward(Vector2(0, 0), ground_friction)

func apply_velocity(delta: float):
	var _no_return = move_and_slide(velocity + knockback, Vector2.ZERO)
	apply_knockback_drag(delta)

func spawn_at(spawn_position: Vector2):
	global_transform.origin = spawn_position
	unextrapolated_physics_position = spawn_position
# warning-ignore:return_value_discarded
	hand.connect("hand_position_updated", self, "_on_hand_position_update")
	for weapon in hand.get_weapons():
		weapon.initialise(hand)

func handle_movement_extrapolation():
	# Extrapolate the player's position in space between physics frames to smooth motion on framerates higher than the physics tickrate
	global_transform.origin = unextrapolated_physics_position
	var _no_return = move_and_collide((velocity + knockback) * ((1.0 / float(Engine.iterations_per_second)) * Engine.get_physics_interpolation_fraction()) * Engine.time_scale)

func _on_hand_position_update():
	var to_hand = (hand.global_transform.origin - global_transform.origin).normalized()
	aimcast.cast_to = to_hand * aimcast_length

func fire_weapon(is_press: bool):
	for weapon in hand.get_weapons():
		weapon.fire(aimcast, self, is_press)

func alt_fire_weapon(is_press: bool):
	for weapon in hand.get_weapons():
		weapon.alternate_fire(aimcast, self, is_press)

func _on_ItemDetectionArea_area_entered(area):
	var parent = area.get_parent() 
	if parent is Weapon and (not pickupable_weapon or (pickupable_weapon and parent != pickupable_weapon.get_ref())):
		hand.set_sprite_action("pickup")
		pickupable_weapon = weakref(parent)

func attempt_weapon_pickup():
	if pickupable_weapon:
		var weapon = pickupable_weapon.get_ref()
		if weapon:
			var parent = weapon.get_parent()
			parent.remove_child(weapon)
			hand.pickup(weapon)
			pickupable_weapon = null

func _on_ItemDetectionArea_area_exited(area):
#	pass
	var parent = area.get_parent() 
	if pickupable_weapon and pickupable_weapon.get_ref() == parent:
		hand.set_sprite_action("together")
		pickupable_weapon = null
