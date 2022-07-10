extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var unextrapolated_physics_position: Vector2 = Vector2.ZERO

export(float) var acceleration: float = 80 # per physics tick
export(float) var max_speed: float = 450
export(float) var ground_friction: float = 15.0 # per physics tick

func _physics_process(_delta):
	# Reset position to last physics frame before applying movement
	global_transform.origin = unextrapolated_physics_position
	apply_acceleration()
	velocity = velocity.normalized() * min(velocity.length(), max_speed)
	apply_friction()
	apply_velocity()
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

func apply_velocity():
	var _no_return = move_and_slide(velocity, Vector2.ZERO)

func handle_movement_extrapolation():
	# Extrapolate the player's position in space between physics frames to smooth motion on framerates higher than the physics tickrate
	global_transform.origin = unextrapolated_physics_position
	var _no_return = move_and_collide(velocity * ((1.0 / float(Engine.iterations_per_second)) * Engine.get_physics_interpolation_fraction()) * Engine.time_scale)
