extends Node2D
class_name Weapon

export(float) var damage: float
export(float) var knockback_magnitude: float
export(bool) var has_alternate_fire: bool = false
export(float) var recoil_magnitude: float = 1.0
export(String, "together", "rifle") var hand_animation_name: String = "together"

onready var sprite = $Sprite
onready var pickup_detection_area: Area2D = $PlayerDetectionArea

var is_dropped: bool = false

var is_ready := true
export(float) var cooldown: float = 1.0

signal alternate_fire_pressed
signal alternate_fire_released

var is_held: bool = false

func initialise(hand):
	pass

func hide():
	sprite.visible = false
	
func show():
	sprite.visible = true
	
func alternate_fire(_aimcast: RayCast2D, _player: KinematicBody2D, is_press: bool):
	if is_press:
		emit_signal("alternate_fire_pressed")
	else:
		emit_signal("alternate_fire_released")


# Just here for an overridable function signature
func fire(_aimcast: RayCast2D, _player: KinematicBody2D, _is_press: bool):
	is_ready = false
	$CooldownTimer.start(cooldown)

func _on_CooldownTimer_timeout():
	is_ready = true

func set_held(value: bool):
	is_held = value

func on_drop():
	pickup_detection_area.monitorable = false
	$PlayerDetectionArea/CollisionShape2D.disabled = false
	is_dropped = true

func on_pickup():
	pickup_detection_area.monitorable = true
	$PlayerDetectionArea/CollisionShape2D.disabled = true
	is_dropped = false
