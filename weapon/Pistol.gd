extends Weapon

func initialise(hand: Hand):
	pass

func alternate_fire(aimcast: RayCast2D, player: KinematicBody2D, is_press: bool):
	.alternate_fire(aimcast, player, is_press)
	if is_press:
		print('alt click')

# Just here for an overridable function signature
func fire(_aimcast: RayCast2D, _player: KinematicBody2D, is_press: bool):
	if is_press:
		print("pistol pew pew")
