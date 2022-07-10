extends Node

var fsm: StateMachine

func enter(e):
	e.velocity = Vector2.ZERO

func exit(_e, next_state):
	fsm._change_to(next_state)

# Optional handler functions for game loop events
func process(e, delta):
	return delta

func physics_process(e, delta):
	return

func input(_e, event):
	return event

func unhandled_input(_e, event):
	return event

func unhandled_key_input(_e, event):
	return event

func notification(what, flag = false):
	return [what, flag]
