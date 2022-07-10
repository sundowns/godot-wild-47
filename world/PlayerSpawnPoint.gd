extends Position2D

onready var debug_image_rect: ColorRect = $DebugImage

func _ready():
	if !Engine.editor_hint:
		debug_image_rect.queue_free()
