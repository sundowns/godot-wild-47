extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	set_as_toplevel(true)
	animation_player.play("Play")

func _on_animation_end():
	queue_free()
