extends Sprite2D

func _process(delta):
	global_position = get_global_mouse_position()
	rotate(deg_to_rad(1))
