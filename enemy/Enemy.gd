extends KinematicBody2D

class_name Enemy

export(float) var max_health: float = 100
export(float) var move_speed: float = 5.0

onready var state_machine: StateMachine = $StateMachine
onready var health = max_health

var velocity = Vector2.ZERO
var can_attack := true
var is_dead := false
var queued_for_death = false

signal heal(new_health)
signal hurt(new_health)
signal dead

func _ready():
# warning-ignore:return_value_discarded
	connect("dead", self, "_on_death")
# warning-ignore:return_value_discarded
	connect("hurt", self, "_on_hurt")
	
func _physics_process(delta):
	pass
	
func update_health(delta: float):
	if is_dead:
		return
	health += delta
	health = clamp(health, 0, max_health)
	if delta < 0:
		emit_signal("hurt", health)
	if delta > 0:
		emit_signal("heal", health)
	if health <= 0:
		emit_signal("dead")
	
func _on_death():
	if !queued_for_death:
		queued_for_death = true
		queue_free()
		
func _on_hurt():
	pass
