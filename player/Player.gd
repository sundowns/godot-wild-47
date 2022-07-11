extends Entity
class_name Player

var velocity: Vector2 = Vector2.ZERO
var unextrapolated_physics_position: Vector2 = Vector2.ZERO

export(float) var acceleration: float = 80 # per physics tick
export(float) var max_speed: float = 450
export(float) var ground_friction: float = 15.0 # per physics tick

onready var hand: Hand = $Hand
onready var head_sprite: Sprite = $HeadSprite
onready var body_sprite: Sprite = $BodySprite

const aimcast_length: int = 10000
onready var aimcast: RayCast2D = $AimCast

func _input(event):
	if event.is_action("fire"):
		fire_weapon(event.is_pressed())
	if event.is_action("alt_fire"):
		alt_fire_weapon(event.is_pressed())

func _physics_process(delta):
	head_sprite.look_at(get_global_mouse_position())
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
		weapon.initialise()

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
